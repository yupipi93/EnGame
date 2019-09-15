ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .area _CODE 
                              2 
                              3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              4 .include "cpctelera.h.s"
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



                              5 
                              6 
                              7 
                              8 
                              9 ;;####################################
                             10 ;; PRIVATE DATA
                             11 ;;####################################
                             12 
                             13 
                             14 ;; enemy Data
   402F 4F                   15 enemy_x: 		.db #80-1		;;End of screen
   4030 52                   16 enemy_y: 		.db #82
   4031 01                   17 enemy_w: 		.db #1 			;;Whidth
   4032 04                   18 enemy_h: 		.db #4 			;;Height
                             19 
   4033 01                   20 direccion:		.db #1			;; 1 = left, 2 = right
                             21 
                             22 
                             23 
                             24 
                             25 
                             26 ;;####################################
                             27 ;; PUBLIC FUNCTIONS ::
                             28 ;;####################################
                             29 
                             30 ;;====================================
                             31 ;; Check collition
                             32 ;; Inputs:
                             33 ;;		HL: Points to the oder entity to check collition
                             34 ;; Return:
                             35 ;; 		XXXXXXXX
                             36 ;;====================================
   4034                      37 enemy_checkCollision::
                             38 
                             39 	;;COSISION IN X:
                             40 
   4034 CD 38 40      [17]   41 	call ifPlayerLeft
                             42 	
                             43 	
   4037 C9            [10]   44 ret
                             45 
   4038                      46 	ifPlayerLeft:
                             47 
                             48 	;; if (EX+EW <= PX) collision_off
                             49 	;;  	(EX+EW - PX <= 0) 
   4038 3A 2F 40      [13]   50 	ld 		a, (enemy_x) 			;; Enemy_X
   403B 4F            [ 4]   51 	ld 		c, a 					;; +
   403C 3A 31 40      [13]   52 	ld  	a, (enemy_w) 			;; Enemy_Whidth
   403F 81            [ 4]   53 	add 	c 						;; -
   4040 96            [ 7]   54 	sub 	(hl) 					;; Player_X???
   4041 28 1E         [12]   55 	jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
   4043 FA 61 40      [10]   56 	jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
   4046 CD 4A 40      [17]   57 	call ifPlayerRigth
   4049 C9            [10]   58 	ret
                             59 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                             60 
   404A                      61 	ifPlayerRigth:
                             62 	;; Other Posibilities
                             63 	;; IF (PX+PWE <= EX) --> (PX+PW-EX <= 0)
                             64 
   404A 7E            [ 7]   65 	ld 		a, (hl) 				;; Player_X
   404B 23            [ 6]   66 	inc 	hl 						;; HL++ (HL+1 = Player_Y)
   404C 23            [ 6]   67 	inc 	hl 						;; HL++ (HL+2 = Player_Width)
   404D 86            [ 7]   68 	add 	(hl) 					;; Player_X + Player_Whidth
   404E 4F            [ 4]   69 	ld 		c, a 					;;
   404F 3A 2F 40      [13]   70 	ld 		a, (enemy_x) 			;; Enemy_X
   4052 47            [ 4]   71 	ld 		b, a 					;; B = Enemy_X
   4053 79            [ 4]   72 	ld 		a, c 					;; A = Player_X + Player_Whidth
   4054 90            [ 4]   73 	sub 	b   					;; Player_X + Player_Whidth  - Enemy_X
   4055 28 0A         [12]   74 	jr 		z, collision_off 		;; if(Resultado == 0) NOT COLLITION
   4057 FA 61 40      [10]   75 	jp 		m, collision_off 		;; if(Resultado < 0) NOT COLLITION
   405A CD 5E 40      [17]   76 	call collision_on
   405D C9            [10]   77 	ret
                             78 
   405E                      79 	collision_on:
                             80 	;; Collision
   405E 3E 0F         [ 7]   81     ld 		a, #0x0F
   4060 C9            [10]   82 	ret
                             83 	;; No collision
   4061                      84 	collision_off:
   4061 3E 00         [ 7]   85 		ld 		a, #00
   4063 C9            [10]   86 	ret
                             87 
                             88 
                             89 
                             90 
                             91 
                             92 ;;====================================
                             93 ;; Erase th enemy
                             94 ;;====================================
                             95 
   4064                      96 enemy_erase::
   4064 3E 00         [ 7]   97 	ld a, #0x00							;;Erase enemy (Backgrownd Color)
   4066 CD BC 40      [17]   98 	call drawEnemy  					;;Draw enemy :D
                             99 
   4069 C9            [10]  100 ret
                            101 
                            102 ;;====================================
                            103 ;; Update the enemy
                            104 ;;====================================
                            105 
   406A                     106 enemy_update::
   406A CD 78 40      [17]  107 	call updateEnemy	
   406D C9            [10]  108 ret
                            109 
                            110 ;;====================================
                            111 ;; Draw the enemy
                            112 ;;====================================
                            113 
   406E                     114 enemy_draw::
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   406E 3E F0         [ 7]  115 	ld a, #0xF0							;;enemy Color RED
   4070 CD BC 40      [17]  116 	call drawEnemy  					;;Draw enemy :D 
                            117 
   4073 C9            [10]  118 ret
                            119 
                            120 ;;====================================
                            121 ;; Draw the enemy
                            122 ;;====================================
   4074                     123 enemy_getX::
                            124 
   4074 3A 2F 40      [13]  125 	ld a, (enemy_x)						;; B = Enemy_X
   4077 C9            [10]  126 ret
                            127 
                            128 
                            129 
                            130 
                            131 ;;####################################
                            132 ;; PRIVATE FUNCTIONS
                            133 ;;####################################
                            134 
                            135 
                            136 
                            137 ;;====================================
                            138 ;; Move enemy right-left
                            139 ;; DESTROY: AF
                            140 ;;====================================
                            141 
   4078                     142 updateEnemy:
   4078 3A 2F 40      [13]  143 	ld 	a,(enemy_x) 					;; Load Enemy_X
   407B FE 4E         [ 7]  144 	cp 	#80-2 							;; |
   407D 28 08         [12]  145 	jr	z, changeToLeft 				;; if (Enemy_X == 79){ changeToLeft (dirrection = 1) }
   407F FE 00         [ 7]  146 	cp 	#0 								;; |
   4081 28 0D         [12]  147 	jr	z, changeToRight 				;; else if (Enemy_X == 0) { changeToRight (direcction = 2)}
                            148 
   4083 CD 99 40      [17]  149 	call moveTo							;; else {move player to direccion}
                            150 
   4086 C9            [10]  151 ret
                            152 
                            153 
                            154 
   4087                     155 changeToLeft: 							
   4087 3E 01         [ 7]  156 	ld 	a, #1 							;; |
   4089 32 33 40      [13]  157 	ld 	(direccion), a 					;; A = 1
   408C CD 99 40      [17]  158 	call moveTo 						;; Move enemy to direction
   408F C9            [10]  159 ret
                            160 
                            161 
   4090                     162 changeToRight:
   4090 3E 02         [ 7]  163 	ld 	a, #2 							;; |
   4092 32 33 40      [13]  164 	ld 	(direccion), a 					;; A = 2
   4095 CD 99 40      [17]  165 	call moveTo 						;; Move Enemy to direction
   4098 C9            [10]  166 ret
                            167 
                            168 
   4099                     169 moveTo:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



   4099 3A 33 40      [13]  170 	ld 	a, (direccion) 					;; A = direction
   409C FE 01         [ 7]  171 	cp 	#1 								;; |
   409E 28 10         [12]  172 	jr 	z, moveEnemyLeft 				;; if (direction = 1 [LEFT]) {Move Enemy to Left}
   40A0 CD A4 40      [17]  173 	call moveEnemyRight					;; else {Move enmey to Right}
                            174 
   40A3 C9            [10]  175 ret
                            176 
                            177 
                            178 
                            179 ;;====================================
                            180 ;; Move enemy Right
                            181 ;; DESTROY: AF
                            182 ;;====================================
   40A4                     183 moveEnemyRight:
                            184 
   40A4 3A 2F 40      [13]  185 	ld a, (enemy_x)					;; A = enemy_x
   40A7 FE 4E         [ 7]  186 	cp #80-2							;; Check if A is (limit of screen - enemy width)
   40A9 28 04         [12]  187 	jr z, dont_move_r						;; Dont move the enemy
                            188 
   40AB 3C            [ 4]  189 		inc a 							;; Else: A++
   40AC 32 2F 40      [13]  190 		ld (enemy_x), a 				;; enemy_x Update
                            191 
   40AF                     192 	dont_move_r:
   40AF C9            [10]  193 ret
                            194 
                            195 
                            196 
                            197 ;;====================================
                            198 ;; Move enemy Left
                            199 ;; DESTROY: AF
                            200 ;;====================================
   40B0                     201 moveEnemyLeft:
                            202 
   40B0 3A 2F 40      [13]  203 	ld a, (enemy_x)					;; A == enemy_x
   40B3 FE 00         [ 7]  204 	cp #0								;; Check if enemy (screen rigth limit)
   40B5 28 04         [12]  205 	jr z, dont_move_l
                            206 	 
   40B7 3D            [ 4]  207 		dec a 							;; Else: A-- (enemy_X--)
   40B8 32 2F 40      [13]  208 		ld (enemy_x), a 				;; enemy_x Update 
                            209 
   40BB                     210 	dont_move_l:
   40BB C9            [10]  211 ret
                            212 
                            213 
                            214 
                            215 
                            216 ;;====================================
                            217 ;; Draw enemy
                            218 ;; INPUTS:
                            219 ;; 		A ==> Color Patern
                            220 ;; DESTROY: AF, BC, DE, HL
                            221 ;;====================================
   40BC                     222 drawEnemy:
                            223 	
   40BC F5            [11]  224 	push af 							;; Save A in Stack
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                            225 	;;Calculate scrren position
   40BD 11 00 C0      [10]  226 	ld 		de, #0xC000					;;Video Memory Pointer
   40C0 3A 2F 40      [13]  227 	ld 		 a, (enemy_x)				;;|
   40C3 4F            [ 4]  228 	ld 		 c, a 						;; C = enemy_x
   40C4 3A 30 40      [13]  229 	ld 		 a, (enemy_y)				;;|
   40C7 47            [ 4]  230 	ld 		 b, a 						;; B = enemy_y
   40C8 CD CF 42      [17]  231 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            232 	
                            233 
                            234 	;; Draw a box
   40CB EB            [ 4]  235 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   40CC F1            [10]  236 	pop 	af							;; A = User Selecter Color
   40CD 01 01 04      [10]  237 	ld 		bc, 	#0x0401				;; 4x4 pixeles
   40D0 CD 22 42      [17]  238 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            239 
   40D3 C9            [10]  240 ret
                            241 
                            242 
                            243 
                            244 
                            245 
                            246 
