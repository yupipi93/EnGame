.area _CODE 
.include "cpctelera.h.s"




;;####################################
;; PRIVATE DATA
;;####################################


;; enemy Data
enemy_x: 		.db #80-1		;;End of screen
enemy_y: 		.db #82
enemy_w: 		.db #1 			;;Whidth
enemy_h: 		.db #4 			;;Height

direccion:		.db #1			;; 1 = left, 2 = right





;;####################################
;; PUBLIC FUNCTIONS ::
;;####################################

;;====================================
;; Gets a pointer to Enemy data in DE
;; DESTROY: DE
;; RETURN: 
;; 		DE: Pointer to Player data
;;====================================
enemy_getPtrDE::
	ld 	de, #enemy_x					;; DE: pointer to player data
ret

;;====================================
;; Check collition
;; Inputs:
;;		HL: Points to the oder entity to check collition
;; Return:
;; 		A: #0x0F = ON, #00 = OFF
;;====================================
enemy_checkCollision::
	ld 	e, #0 				;; E = Collisions_Counter
	;; Collision in X:
	call ifPlayerLeft 		;; Check if player is Left, if not (E++)
	call ifPlayerRigth		;; Check if player is Right, if not (E++)
	;; Collision in Y:
	call ifPlayerUp 		;; Check Collition in Y (E++)
	;;call ifPlauerDown 		;; Check Collition in Y (E++)

	ld 	a, e 				;; |
	cp 	#3 					;; if Collisions_Counter == 2 (not left + not right)
	jr	z,led_on 			;; LED_ON
	call led_off 			;; Then LED_OFF
ret

;; Collision
led_on:
	ld 		a, #0x0F
ret

;; No collision
led_off:
	ld 		a, #00
ret
	
	


	ifPlayerLeft:
		;; if (EX+EW <= PX) collision_off
		;;  	(EX+EW - PX <= 0) 
		ld 		a, (enemy_x) 			;; Enemy_X
		ld 		c, a 					;; +
		ld  	a, (enemy_w) 			;; Enemy_Whidth
		add 	c 						;; -
		sub 	(hl) 					;; Player_X???
		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
		call 	collision_on			;; COLLISION
	ret


	ifPlayerRigth:	
		;; IF (PX+PWE <= EX) --> (PX+PW-EX <= 0)
		ld 		a, (hl) 				;; Player_X
		inc 	hl 						;; HL++ (HL+1 = Player_Y)
		inc 	hl 						;; HL++ (HL+2 = Player_Width)
		add 	(hl) 					;; Player_X + Player_Whidth
		ld 		c, a 					;;
		ld 		a, (enemy_x) 			;; Enemy_X
		ld 		b, a 					;; B = Enemy_X
		ld 		a, c 					;; A = Player_X + Player_Whidth
		sub 	b   					;; Player_X + Player_Whidth  - Enemy_X
		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
		call 	collision_on
	ret

	;; Other Posibilities Y

	ifPlayerUp:
    	;; If(EY >= PY+PH) --> if(EY - PY+PH >= 0)
    	inc 	hl 					;; | (After HL+2) Load Player DATA (X,Y,W,H)
    	ld 		a, (hl)  			;; A = Player_H
    	dec 	hl 					;; HL--
    	dec 	hl 					;; HL-- = Player_Y
    	add 	(hl) 				;; |
    	ld 		c, a 				;; C = Player_H + Player_Y
    	ld 		a, (enemy_y) 		;; |
    	sub 	c 					;; Enemy_Y - C
    	jr 		z,collision_off 	;; if (== 0) NOT COLLISION
    	jp 		p,collision_off     ;; if (<) 0) NOT COLLISION
    	call 	collision_on
	ret

	collision_on:
    	inc 	e
	ret

	collision_off:
		;;Nothing
	ret





;;====================================
;; Erase th enemy
;;====================================

enemy_erase::
	ld a, #0x00							;;Erase enemy (Backgrownd Color)
	call drawEnemy  					;;Draw enemy :D

ret

;;====================================
;; Update the enemy
;;====================================

enemy_update::
	call updateEnemy	
ret

;;====================================
;; Draw the enemy
;;====================================

enemy_draw::
	ld a, #0xF0							;;enemy Color RED
	call drawEnemy  					;;Draw enemy :D 

ret






;;####################################
;; PRIVATE FUNCTIONS
;;####################################



;;====================================
;; Move enemy right-left
;; DESTROY: AF
;;====================================

updateEnemy:
	ld 	a,(enemy_x) 					;; Load Enemy_X
	cp 	#80-2 							;; |
	jr	z, changeToLeft 				;; if (Enemy_X == 79){ changeToLeft (dirrection = 1) }
	cp 	#0 								;; |
	jr	z, changeToRight 				;; else if (Enemy_X == 0) { changeToRight (direcction = 2)}

	call moveTo							;; else {move player to direccion}

ret



changeToLeft: 							
	ld 	a, #1 							;; |
	ld 	(direccion), a 					;; A = 1
	call moveTo 						;; Move enemy to direction
ret


changeToRight:
	ld 	a, #2 							;; |
	ld 	(direccion), a 					;; A = 2
	call moveTo 						;; Move Enemy to direction
ret


moveTo:
	ld 	a, (direccion) 					;; A = direction
	cp 	#1 								;; |
	jr 	z, moveEnemyLeft 				;; if (direction = 1 [LEFT]) {Move Enemy to Left}
	call moveEnemyRight					;; else {Move enmey to Right}

ret



;;====================================
;; Move enemy Right
;; DESTROY: AF
;;====================================
moveEnemyRight:

	ld a, (enemy_x)					;; A = enemy_x
	cp #80-2							;; Check if A is (limit of screen - enemy width)
	jr z, dont_move_r						;; Dont move the enemy

		inc a 							;; Else: A++
		ld (enemy_x), a 				;; enemy_x Update

	dont_move_r:
ret



;;====================================
;; Move enemy Left
;; DESTROY: AF
;;====================================
moveEnemyLeft:

	ld a, (enemy_x)					;; A == enemy_x
	cp #0								;; Check if enemy (screen rigth limit)
	jr z, dont_move_l
	 
		dec a 							;; Else: A-- (enemy_X--)
		ld (enemy_x), a 				;; enemy_x Update 

	dont_move_l:
ret




;;====================================
;; Draw enemy
;; INPUTS:
;; 		A ==> Color Patern
;; DESTROY: AF, BC, DE, HL
;;====================================
drawEnemy:
	
	push af 							;; Save A in Stack
	;;Calculate scrren position
	ld 		de, #0xC000					;;Video Memory Pointer
	ld 		 a, (enemy_x)				;;|
	ld 		 c, a 						;; C = enemy_x
	ld 		 a, (enemy_y)				;;|
	ld 		 b, a 						;; B = enemy_y
	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
	

	;; Draw a box
	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
	pop 	af							;; A = User Selecter Color
	ld 		bc, 	#0x0401				;; 4x4 pixeles
	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox

ret






