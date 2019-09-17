.area _CODE 
.include "cpctelera.h.s"


;;####################################
;; PRIVATE DATA
;;####################################


;;####################################
;; PUBLIC FUNCTIONS ::
;;####################################

;;====================================
;; Check collision (A<-->B)
;; Inputs:
;;		HL: Points to entity A (X,Y,H,W)
;;		DE: Points to entiti B (X,Y,H,W)
;; Return:
;; 		A: #0x0F = ON, #00 = OFF
;;====================================

checkCollision::
	ld 	l, #0 				;; E = Collisions_Counter (4==Collision)
	
	;; Collision in X:
	call ifEntityLeft 		;; Check if other entity is Left, if not (E++)
	call ifEntityRigth		;; Check if other entity is Right, if not (E++)
	
	;; Collision in Y:
	call ifEntityUp 		;; Check Collition in Y (E++)
	;;call ifEntityDown 	;; Check Collition in Y (E++)

	ld 	a, l 				;; |
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
	
	







;;####################################
;; PRIVATE FUNCTIONS
;;####################################



	ifEntityLeft:
		;; if (EntityA_X + Entity_A_W <= EntityB_X) collision_off
		;;  transform	(EntityA_X + Entity_A_W - EntityB_X <= 0) 
		ld 		a, (de)					;; EntityA_X
		ld 		c, a 					;; +
		inc 	de 						;; 						DE = EntityA_Y
		inc 	de 						;; 						DE = EntityA_W
		ld  	a, (de) 				;; Entity_W
		add 	c 						;; -
		sub 	(hl) 					;; Player_X???
		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
		call 	collision_on			;; COLLISION
	ret


	ifEntityRigth:	
		;; IF (EntityB_X + EntityB_W <= EntityA_X) 
		;; Transform (EntityB_X + EntityB_W - EntityA_X <= 0)
		ld 		a, (hl) 				;; Player_X
		inc 	hl 						;; HL++ (HL+1 = Player_Y)
		inc 	hl 						;; HL++ (HL+2 = Player_Width)
		add 	(hl) 					;; Player_X + Player_Whidth
		ld 		c, a 					;;
		dec 	de 						;; 				DE = EntityA_Y
		dec 	de 						;;				DE = EntityA_X
		ld 		a, (de) 				;; EntityA_X
		ld 		b, a 					;; B = Enemy_X
		ld 		a, c 					;; A = Player_X + Player_Whidth
		sub 	b   					;; Player_X + Player_Whidth  - Enemy_X
		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
		call 	collision_on
	ret

	;; Other Posibilities Y

	ifEntityUp:
    	;; If(EntityA_Y >= EntityB_Y + EntityB_H) 
    	;; Transform if(EntityA_Y - EntityB_Y + EntityB_H >= 0)
    	inc 	hl 					;; | (After HL+2) Load Player DATA (X,Y,W,H)
    	ld 		a, (hl)  			;; A = Player_H
    	dec 	hl 					;; HL--
    	dec 	hl 					;; HL-- = Player_Y
    	add 	(hl) 				;; |
    	ld 		c, a 				;; C = Player_H + Player_Y
    	inc 	de 					;; 					DE = EntityA_Y
    	ld 		a, (de) 			;; |
    	sub 	c 					;; Enemy_Y - C
    	jr 		z,collision_off 	;; if (== 0) NOT COLLISION
    	jp 		p,collision_off     ;; if (<) 0) NOT COLLISION
    	call 	collision_on
	ret

	collision_on:
    	inc 	l
	ret

	collision_off:
		;;Nothing
	ret
