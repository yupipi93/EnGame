.area _CODE 

.include "keyboard/keyboard.s"
.include "cpctelera.h.s"

;;####################################
;; PRIVATE DATA
;;####################################


;; Player Data
player_x: 		.db #39
player_y: 		.db #80
player_w: 		.db #2 			;;Whidth
player_h: 		.db #8 			;;Height

player_jump:	.db #-1

;; Jump Table
jumpTable:
	.db 	#-3, #-2, #-1, #-1
	.db 	#-1, #00, #00, #00
	.db 	#01, #02, #02, #03
	.db 	#0x80

floor_x: 		.db #00
floor_y:		.db #88






;;####################################
;; PUBLIC FUNCTIONS ::
;;####################################


;;====================================
;; Erase th Player
;;====================================

player_erase::
	ld a, #0x00							;;Erase Player (Backgrownd Color)
	call drawPlayer 					;;Draw player :D

ret

;;====================================
;; Update the Player
;;====================================

player_update::
	call jumpControl 					;;Do Jump
	call HandleEvent 					;;Keyboard check

ret

;;====================================
;; Draw the Player
;;====================================

player_draw::
	ld a, #0xFF							;;Player Color RED
	call drawPlayer 					;;Draw player :D 

ret


;;====================================
;; Gets a pointer to Player data in HL
;; DESTROY: HL
;; RETURN: 
;; 		HL: Pointer to Player data
;;====================================

player_getPtrHL::
	ld 	hl, #player_x 					;; HL: pointer to player data
ret





;;####################################
;; PRIVATE FUNCTIONS
;;####################################





;;====================================
;; Controls Jump Momevemnts
;; DESTROY: 
;;====================================
jumpControl:
	ld		 a, (player_jump)			;; A = Player Jump Status
	cp 		#-1							;; A == -1? (-1 is not jump)
	ret 	z							;; If A == -1, not jumping, so ret

	;; Ger Jumps Values
	ld		hl, #jumpTable				;; Load JumpTable Pointer
	ld 		 b, #0						;; |
	ld 		 c, a 						;; BC = A (Offset)
	add 	hl, bc 						;; HL += BC

	;; Check end jump
	ld 		a, (hl) 					;; A = jump Movement
	cp 		#0x80 						;; Jump value == 0
	jr 		z, end_of_jump 				;; If 0x80 end of jump

	;; Do Jump Movement
	ld 		 b, a						;; B = Fist Position TableJump
	ld 		 a, (player_y)				;; A = Player_Y
	add 	 b 							;; A += B (Add jump movmenet)
	ld 		(player_y), a 				;; Update Hero_Y value

	;; Increase Player_jump Index
	ld 		a, (player_jump) 			;; A = Player_jump
	inc 	a 							;; |
	ld 		(player_jump), a 			;; Player_jump++


ret

;; Put -1 in jump status
end_of_jump:
	ld 		a, #-1 						;; |
	ld 		(player_jump),a 			;; Player_jump = -1
ret

;;====================================
;; Start Player Jump
;; DESTROY: AF
;;====================================
startJump:

	ld 	a, (player_jump)				;; A = Player_jump
	cp 	#-1 							;; A == -1?  Jump is active?	
	ret nz 								;; Jump Active, return

	;; Jump is Inactive, Active it!
	ld 	a, #0 							 
	ld (player_jump), a 
ret



;;====================================
;; Move Player Right
;; DESTROY: AF
;;====================================
movePlayerRight:

	ld a, (player_x)					;; A = Player_x
	cp #80-2							;; Check if A is (limit of screen - player width)
	jr z, dont_move_r						;; Dont move the player

		inc a 							;; Else: A++
		ld (player_x), a 				;; Player_x Update

	dont_move_r:
ret



;;====================================
;; Move Player Left
;; DESTROY: AF
;;====================================
movePlayerLeft:

	ld a, (player_x)					;; A == Player_x
	cp #0								;; Check if player (screen rigth limit)
	jr z, dont_move_l
	 
		dec a 							;; Else: A-- (Player_X--)
		ld (player_x), a 				;; Player_x Update 

	dont_move_l:
ret

;;====================================
;; Handle Events
;; DESTROY: AF, BC, DE, HL
;;====================================
HandleEvent:
	call check_KeyD_pressed
	call check_KeyA_pressed
	call check_KeyW_pressed
	
		check_KeyD_pressed:
			call cpct_scanKeyboard_asm			;; Scan all keyboard
			ld hl, #Key_D 						;; HL = KEY 'D' Code
			call cpct_isKeyPressed_asm			;; Check for key 'D' is presed
			cp #0 								;; Check A == 0
			jr z, d_not_pressed					;; Jump if A == 0 ('D' not pressed)
				
				call movePlayerRight			;; 'D' is pressed
		
			d_not_pressed:						;; Do nothing
		
		ret

		check_KeyA_pressed:
			call cpct_scanKeyboard_asm			;; Scan all keyboard
			ld hl, #Key_A 						;; HL = KEY 'A' Code
			call cpct_isKeyPressed_asm			;; Check for key 'A' is presed
			cp #0 								;; Check A == 0
			jr z, a_not_pressed					;; Jump if A == 0 ('A' not pressed)
		
				call movePlayerLeft				;; 'A' is pressed
		
			a_not_pressed:						;; Do nothing

		ret

		check_KeyW_pressed:
			call cpct_scanKeyboard_asm			;; Scan all keyboard
			ld hl, #Key_W 						;; HL = KEY 'W' Code
			call cpct_isKeyPressed_asm			;; Check for key 'W' is presed
			cp #0 								;; Check A == 0
			jr z, w_not_pressed					;; Jump if A == 0 ('W' not pressed)
		
				call startJump					;; 'W' is pressed
		
			w_not_pressed:						;; Do nothing

		ret


ret
;;====================================
;; Draw Player
;; INPUTS:
;; 		A ==> Color Patern
;; DESTROY: AF, BC, DE, HL
;;====================================
drawPlayer:
	
	push af 							;; Save A in Stack
	;;Calculate scrren position
	ld 		de, #0xC000					;;Video Memory Pointer
	ld 		 a, (player_x)				;;|
	ld 		 c, a 						;; C = Player_x
	ld 		 a, (player_y)				;;|
	ld 		 b, a 						;; B = Player_y
	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
	

	;; Draw a box
	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
	pop 	af							;; A = User Selecter Color
	ld 		bc, 	#0x0802				;; 8x8 pixeles
	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox

ret







