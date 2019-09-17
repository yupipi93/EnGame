ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .area _CODE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              2 .include "cpctelera.h.s"
                              1 ;; CPCtelera Symbols
                              2 .globl cpct_drawSolidBox_asm
                              3 .globl cpct_getScreenPtr_asm
                              4 
                              5 .globl cpct_scanKeyboard_asm
                              6 .globl cpct_isKeyPressed_asm
                              7 
                              8 .globl cpct_waitVSYNC_asm
                              9 .globl cpct_disableFirmware_asm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              3 
                              4 
                              5 ;;####################################
                              6 ;; PRIVATE DATA
                              7 ;;####################################
                              8 
                              9 
                             10 ;;####################################
                             11 ;; PUBLIC FUNCTIONS ::
                             12 ;;####################################
                             13 
                             14 ;;====================================
                             15 ;; Check collision (A<-->B)
                             16 ;; Inputs:
                             17 ;;		HL: Points to entity A (X,Y,H,W)
                             18 ;;		DE: Points to entiti B (X,Y,H,W)
                             19 ;; Return:
                             20 ;; 		A: #0x0F = ON, #00 = OFF
                             21 ;;====================================
                             22 
   4033                      23 checkCollision::
   4033 2E 00         [ 7]   24 	ld 	l, #0 				;; E = Collisions_Counter (4==Collision)
                             25 	
                             26 	;; Collision in X:
   4035 CD 4D 40      [17]   27 	call ifEntityLeft 		;; Check if other entity is Left, if not (E++)
   4038 CD 5D 40      [17]   28 	call ifEntityRigth		;; Check if other entity is Right, if not (E++)
                             29 	
                             30 	;; Collision in Y:
   403B CD 71 40      [17]   31 	call ifEntityUp 		;; Check Collition in Y (E++)
                             32 	;;call ifEntityDown 	;; Check Collition in Y (E++)
                             33 
   403E 7D            [ 4]   34 	ld 	a, l 				;; |
   403F FE 03         [ 7]   35 	cp 	#3 					;; if Collisions_Counter == 2 (not left + not right)
   4041 28 04         [12]   36 	jr	z,led_on 			;; LED_ON
   4043 CD 4A 40      [17]   37 	call led_off 			;; Then LED_OFF
   4046 C9            [10]   38 ret
                             39 
                             40 ;; Collision
   4047                      41 led_on:
   4047 3E 0F         [ 7]   42 	ld 		a, #0x0F
   4049 C9            [10]   43 ret
                             44 
                             45 ;; No collision
   404A                      46 led_off:
   404A 3E 00         [ 7]   47 	ld 		a, #00
   404C C9            [10]   48 ret
                             49 	
                             50 	
                             51 
                             52 
                             53 
                             54 
                             55 
                             56 
                             57 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                             58 ;;####################################
                             59 ;; PRIVATE FUNCTIONS
                             60 ;;####################################
                             61 
                             62 
                             63 
   404D                      64 	ifEntityLeft:
                             65 		;; if (EntityA_X + Entity_A_W <= EntityB_X) collision_off
                             66 		;;  transform	(EntityA_X + Entity_A_W - EntityB_X <= 0) 
   404D 1A            [ 7]   67 		ld 		a, (de)					;; EntityA_X
   404E 4F            [ 4]   68 		ld 		c, a 					;; +
   404F 13            [ 6]   69 		inc 	de 						;; 						DE = EntityA_Y
   4050 13            [ 6]   70 		inc 	de 						;; 						DE = EntityA_W
   4051 1A            [ 7]   71 		ld  	a, (de) 				;; Entity_W
   4052 81            [ 4]   72 		add 	c 						;; -
   4053 96            [ 7]   73 		sub 	(hl) 					;; Player_X???
   4054 28 2F         [12]   74 		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
   4056 FA 85 40      [10]   75 		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
   4059 CD 83 40      [17]   76 		call 	collision_on			;; COLLISION
   405C C9            [10]   77 	ret
                             78 
                             79 
   405D                      80 	ifEntityRigth:	
                             81 		;; IF (EntityB_X + EntityB_W <= EntityA_X) 
                             82 		;; Transform (EntityB_X + EntityB_W - EntityA_X <= 0)
   405D 7E            [ 7]   83 		ld 		a, (hl) 				;; Player_X
   405E 23            [ 6]   84 		inc 	hl 						;; HL++ (HL+1 = Player_Y)
   405F 23            [ 6]   85 		inc 	hl 						;; HL++ (HL+2 = Player_Width)
   4060 86            [ 7]   86 		add 	(hl) 					;; Player_X + Player_Whidth
   4061 4F            [ 4]   87 		ld 		c, a 					;;
   4062 1B            [ 6]   88 		dec 	de 						;; 				DE = EntityA_Y
   4063 1B            [ 6]   89 		dec 	de 						;;				DE = EntityA_X
   4064 1A            [ 7]   90 		ld 		a, (de) 				;; EntityA_X
   4065 47            [ 4]   91 		ld 		b, a 					;; B = Enemy_X
   4066 79            [ 4]   92 		ld 		a, c 					;; A = Player_X + Player_Whidth
   4067 90            [ 4]   93 		sub 	b   					;; Player_X + Player_Whidth  - Enemy_X
   4068 28 1B         [12]   94 		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
   406A FA 85 40      [10]   95 		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
   406D CD 83 40      [17]   96 		call 	collision_on
   4070 C9            [10]   97 	ret
                             98 
                             99 	;; Other Posibilities Y
                            100 
   4071                     101 	ifEntityUp:
                            102     	;; If(EntityA_Y >= EntityB_Y + EntityB_H) 
                            103     	;; Transform if(EntityA_Y - EntityB_Y + EntityB_H >= 0)
   4071 23            [ 6]  104     	inc 	hl 					;; | (After HL+2) Load Player DATA (X,Y,W,H)
   4072 7E            [ 7]  105     	ld 		a, (hl)  			;; A = Player_H
   4073 2B            [ 6]  106     	dec 	hl 					;; HL--
   4074 2B            [ 6]  107     	dec 	hl 					;; HL-- = Player_Y
   4075 86            [ 7]  108     	add 	(hl) 				;; |
   4076 4F            [ 4]  109     	ld 		c, a 				;; C = Player_H + Player_Y
   4077 13            [ 6]  110     	inc 	de 					;; 					DE = EntityA_Y
   4078 1A            [ 7]  111     	ld 		a, (de) 			;; |
   4079 91            [ 4]  112     	sub 	c 					;; Enemy_Y - C
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   407A 28 09         [12]  113     	jr 		z,collision_off 	;; if (== 0) NOT COLLISION
   407C F2 85 40      [10]  114     	jp 		p,collision_off     ;; if (<) 0) NOT COLLISION
   407F CD 83 40      [17]  115     	call 	collision_on
   4082 C9            [10]  116 	ret
                            117 
   4083                     118 	collision_on:
   4083 1C            [ 4]  119     	inc 	e
   4084 C9            [10]  120 	ret
                            121 
   4085                     122 	collision_off:
                            123 		;;Nothing
   4085 C9            [10]  124 	ret
