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
                              5 
                              6 
                              7 ;;####################################
                              8 ;; PRIVATE DATA
                              9 ;;####################################
                             10 
                             11 
                             12 ;; enemy Data
   4086 4F                   13 enemy_x: 		.db #80-1		;;End of screen
   4087 52                   14 enemy_y: 		.db #82
   4088 01                   15 enemy_w: 		.db #1 			;;Whidth
   4089 04                   16 enemy_h: 		.db #4 			;;Height
                             17 
   408A 01                   18 direccion:		.db #1			;; 1 = left, 2 = right
                             19 
                             20 
                             21 
                             22 
                             23 
                             24 ;;####################################
                             25 ;; PUBLIC FUNCTIONS ::
                             26 ;;####################################
                             27 
                             28 ;;====================================
                             29 ;; Gets a pointer to Enemy data in DE
                             30 ;; DESTROY: DE
                             31 ;; RETURN: 
                             32 ;; 		DE: Pointer to Player data
                             33 ;;====================================
   408B                      34 enemy_getPtrDE::
   408B 11 86 40      [10]   35 	ld 	de, #enemy_x					;; DE: pointer to player data
   408E C9            [10]   36 ret
                             37 
                             38 ;;====================================
                             39 ;; Check collition
                             40 ;; Inputs:
                             41 ;;		HL: Points to the oder entity to check collition
                             42 ;; Return:
                             43 ;; 		A: #0x0F = ON, #00 = OFF
                             44 ;;====================================
   408F                      45 enemy_checkCollision::
   408F 1E 00         [ 7]   46 	ld 	e, #0 				;; E = Collisions_Counter
                             47 	;; Collision in X:
   4091 CD A9 40      [17]   48 	call ifPlayerLeft 		;; Check if player is Left, if not (E++)
   4094 CD BB 40      [17]   49 	call ifPlayerRigth		;; Check if player is Right, if not (E++)
                             50 	;; Collision in Y:
   4097 CD CF 40      [17]   51 	call ifPlayerUp 		;; Check Collition in Y (E++)
                             52 	;;call ifPlauerDown 		;; Check Collition in Y (E++)
                             53 
   409A 7B            [ 4]   54 	ld 	a, e 				;; |
   409B FE 03         [ 7]   55 	cp 	#3 					;; if Collisions_Counter == 2 (not left + not right)
   409D 28 04         [12]   56 	jr	z,led_on 			;; LED_ON
   409F CD A6 40      [17]   57 	call led_off 			;; Then LED_OFF
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



   40A2 C9            [10]   58 ret
                             59 
                             60 ;; Collision
   40A3                      61 led_on:
   40A3 3E 0F         [ 7]   62 	ld 		a, #0x0F
   40A5 C9            [10]   63 ret
                             64 
                             65 ;; No collision
   40A6                      66 led_off:
   40A6 3E 00         [ 7]   67 	ld 		a, #00
   40A8 C9            [10]   68 ret
                             69 	
                             70 	
                             71 
                             72 
   40A9                      73 	ifPlayerLeft:
                             74 		;; if (EX+EW <= PX) collision_off
                             75 		;;  	(EX+EW - PX <= 0) 
   40A9 3A 86 40      [13]   76 		ld 		a, (enemy_x) 			;; Enemy_X
   40AC 4F            [ 4]   77 		ld 		c, a 					;; +
   40AD 3A 88 40      [13]   78 		ld  	a, (enemy_w) 			;; Enemy_Whidth
   40B0 81            [ 4]   79 		add 	c 						;; -
   40B1 96            [ 7]   80 		sub 	(hl) 					;; Player_X???
   40B2 28 30         [12]   81 		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
   40B4 FA E4 40      [10]   82 		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
   40B7 CD E2 40      [17]   83 		call 	collision_on			;; COLLISION
   40BA C9            [10]   84 	ret
                             85 
                             86 
   40BB                      87 	ifPlayerRigth:	
                             88 		;; IF (PX+PWE <= EX) --> (PX+PW-EX <= 0)
   40BB 7E            [ 7]   89 		ld 		a, (hl) 				;; Player_X
   40BC 23            [ 6]   90 		inc 	hl 						;; HL++ (HL+1 = Player_Y)
   40BD 23            [ 6]   91 		inc 	hl 						;; HL++ (HL+2 = Player_Width)
   40BE 86            [ 7]   92 		add 	(hl) 					;; Player_X + Player_Whidth
   40BF 4F            [ 4]   93 		ld 		c, a 					;;
   40C0 3A 86 40      [13]   94 		ld 		a, (enemy_x) 			;; Enemy_X
   40C3 47            [ 4]   95 		ld 		b, a 					;; B = Enemy_X
   40C4 79            [ 4]   96 		ld 		a, c 					;; A = Player_X + Player_Whidth
   40C5 90            [ 4]   97 		sub 	b   					;; Player_X + Player_Whidth  - Enemy_X
   40C6 28 1C         [12]   98 		jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
   40C8 FA E4 40      [10]   99 		jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
   40CB CD E2 40      [17]  100 		call 	collision_on
   40CE C9            [10]  101 	ret
                            102 
                            103 	;; Other Posibilities Y
                            104 
   40CF                     105 	ifPlayerUp:
                            106     	;; If(EY >= PY+PH) --> if(EY - PY+PH >= 0)
   40CF 23            [ 6]  107     	inc 	hl 					;; | (After HL+2) Load Player DATA (X,Y,W,H)
   40D0 7E            [ 7]  108     	ld 		a, (hl)  			;; A = Player_H
   40D1 2B            [ 6]  109     	dec 	hl 					;; HL--
   40D2 2B            [ 6]  110     	dec 	hl 					;; HL-- = Player_Y
   40D3 86            [ 7]  111     	add 	(hl) 				;; |
   40D4 4F            [ 4]  112     	ld 		c, a 				;; C = Player_H + Player_Y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   40D5 3A 87 40      [13]  113     	ld 		a, (enemy_y) 		;; |
   40D8 91            [ 4]  114     	sub 	c 					;; Enemy_Y - C
   40D9 28 09         [12]  115     	jr 		z,collision_off 	;; if (== 0) NOT COLLISION
   40DB F2 E4 40      [10]  116     	jp 		p,collision_off     ;; if (<) 0) NOT COLLISION
   40DE CD E2 40      [17]  117     	call 	collision_on
   40E1 C9            [10]  118 	ret
                            119 
   40E2                     120 	collision_on:
   40E2 1C            [ 4]  121     	inc 	e
   40E3 C9            [10]  122 	ret
                            123 
   40E4                     124 	collision_off:
                            125 		;;Nothing
   40E4 C9            [10]  126 	ret
                            127 
                            128 
                            129 
                            130 
                            131 
                            132 ;;====================================
                            133 ;; Erase th enemy
                            134 ;;====================================
                            135 
   40E5                     136 enemy_erase::
   40E5 3E 00         [ 7]  137 	ld a, #0x00							;;Erase enemy (Backgrownd Color)
   40E7 CD 39 41      [17]  138 	call drawEnemy  					;;Draw enemy :D
                            139 
   40EA C9            [10]  140 ret
                            141 
                            142 ;;====================================
                            143 ;; Update the enemy
                            144 ;;====================================
                            145 
   40EB                     146 enemy_update::
   40EB CD F5 40      [17]  147 	call updateEnemy	
   40EE C9            [10]  148 ret
                            149 
                            150 ;;====================================
                            151 ;; Draw the enemy
                            152 ;;====================================
                            153 
   40EF                     154 enemy_draw::
   40EF 3E F0         [ 7]  155 	ld a, #0xF0							;;enemy Color RED
   40F1 CD 39 41      [17]  156 	call drawEnemy  					;;Draw enemy :D 
                            157 
   40F4 C9            [10]  158 ret
                            159 
                            160 
                            161 
                            162 
                            163 
                            164 
                            165 ;;####################################
                            166 ;; PRIVATE FUNCTIONS
                            167 ;;####################################
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                            168 
                            169 
                            170 
                            171 ;;====================================
                            172 ;; Move enemy right-left
                            173 ;; DESTROY: AF
                            174 ;;====================================
                            175 
   40F5                     176 updateEnemy:
   40F5 3A 86 40      [13]  177 	ld 	a,(enemy_x) 					;; Load Enemy_X
   40F8 FE 4E         [ 7]  178 	cp 	#80-2 							;; |
   40FA 28 08         [12]  179 	jr	z, changeToLeft 				;; if (Enemy_X == 79){ changeToLeft (dirrection = 1) }
   40FC FE 00         [ 7]  180 	cp 	#0 								;; |
   40FE 28 0D         [12]  181 	jr	z, changeToRight 				;; else if (Enemy_X == 0) { changeToRight (direcction = 2)}
                            182 
   4100 CD 16 41      [17]  183 	call moveTo							;; else {move player to direccion}
                            184 
   4103 C9            [10]  185 ret
                            186 
                            187 
                            188 
   4104                     189 changeToLeft: 							
   4104 3E 01         [ 7]  190 	ld 	a, #1 							;; |
   4106 32 8A 40      [13]  191 	ld 	(direccion), a 					;; A = 1
   4109 CD 16 41      [17]  192 	call moveTo 						;; Move enemy to direction
   410C C9            [10]  193 ret
                            194 
                            195 
   410D                     196 changeToRight:
   410D 3E 02         [ 7]  197 	ld 	a, #2 							;; |
   410F 32 8A 40      [13]  198 	ld 	(direccion), a 					;; A = 2
   4112 CD 16 41      [17]  199 	call moveTo 						;; Move Enemy to direction
   4115 C9            [10]  200 ret
                            201 
                            202 
   4116                     203 moveTo:
   4116 3A 8A 40      [13]  204 	ld 	a, (direccion) 					;; A = direction
   4119 FE 01         [ 7]  205 	cp 	#1 								;; |
   411B 28 10         [12]  206 	jr 	z, moveEnemyLeft 				;; if (direction = 1 [LEFT]) {Move Enemy to Left}
   411D CD 21 41      [17]  207 	call moveEnemyRight					;; else {Move enmey to Right}
                            208 
   4120 C9            [10]  209 ret
                            210 
                            211 
                            212 
                            213 ;;====================================
                            214 ;; Move enemy Right
                            215 ;; DESTROY: AF
                            216 ;;====================================
   4121                     217 moveEnemyRight:
                            218 
   4121 3A 86 40      [13]  219 	ld a, (enemy_x)					;; A = enemy_x
   4124 FE 4E         [ 7]  220 	cp #80-2							;; Check if A is (limit of screen - enemy width)
   4126 28 04         [12]  221 	jr z, dont_move_r						;; Dont move the enemy
                            222 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   4128 3C            [ 4]  223 		inc a 							;; Else: A++
   4129 32 86 40      [13]  224 		ld (enemy_x), a 				;; enemy_x Update
                            225 
   412C                     226 	dont_move_r:
   412C C9            [10]  227 ret
                            228 
                            229 
                            230 
                            231 ;;====================================
                            232 ;; Move enemy Left
                            233 ;; DESTROY: AF
                            234 ;;====================================
   412D                     235 moveEnemyLeft:
                            236 
   412D 3A 86 40      [13]  237 	ld a, (enemy_x)					;; A == enemy_x
   4130 FE 00         [ 7]  238 	cp #0								;; Check if enemy (screen rigth limit)
   4132 28 04         [12]  239 	jr z, dont_move_l
                            240 	 
   4134 3D            [ 4]  241 		dec a 							;; Else: A-- (enemy_X--)
   4135 32 86 40      [13]  242 		ld (enemy_x), a 				;; enemy_x Update 
                            243 
   4138                     244 	dont_move_l:
   4138 C9            [10]  245 ret
                            246 
                            247 
                            248 
                            249 
                            250 ;;====================================
                            251 ;; Draw enemy
                            252 ;; INPUTS:
                            253 ;; 		A ==> Color Patern
                            254 ;; DESTROY: AF, BC, DE, HL
                            255 ;;====================================
   4139                     256 drawEnemy:
                            257 	
   4139 F5            [11]  258 	push af 							;; Save A in Stack
                            259 	;;Calculate scrren position
   413A 11 00 C0      [10]  260 	ld 		de, #0xC000					;;Video Memory Pointer
   413D 3A 86 40      [13]  261 	ld 		 a, (enemy_x)				;;|
   4140 4F            [ 4]  262 	ld 		 c, a 						;; C = enemy_x
   4141 3A 87 40      [13]  263 	ld 		 a, (enemy_y)				;;|
   4144 47            [ 4]  264 	ld 		 b, a 						;; B = enemy_y
   4145 CD F8 42      [17]  265 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            266 	
                            267 
                            268 	;; Draw a box
   4148 EB            [ 4]  269 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   4149 F1            [10]  270 	pop 	af							;; A = User Selecter Color
   414A 01 01 04      [10]  271 	ld 		bc, 	#0x0401				;; 4x4 pixeles
   414D CD 4B 42      [17]  272 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            273 
   4150 C9            [10]  274 ret
                            275 
                            276 
                            277 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                            278 
                            279 
                            280 
