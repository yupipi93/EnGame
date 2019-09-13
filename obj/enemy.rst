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
   4023 4F                   15 enemy_x: 		.db #80-1		;;End of screen
   4024 52                   16 enemy_y: 		.db #82
   4025 01                   17 direccion:		.db #1			;; 1 = left, 2 = right
                             18 
                             19 
                             20 
                             21 
                             22 
                             23 ;;####################################
                             24 ;; PUBLIC FUNCTIONS ::
                             25 ;;####################################
                             26 
                             27 
                             28 ;;====================================
                             29 ;; Erase th enemy
                             30 ;;====================================
                             31 
   4026                      32 enemy_erase::
   4026 3E 00         [ 7]   33 	ld a, #0x00							;;Erase enemy (Backgrownd Color)
   4028 CD 7E 40      [17]   34 	call drawEnemy  					;;Draw enemy :D
                             35 
   402B C9            [10]   36 ret
                             37 
                             38 ;;====================================
                             39 ;; Update the enemy
                             40 ;;====================================
                             41 
   402C                      42 enemy_update::
   402C CD 3A 40      [17]   43 	call updateEnemy	
   402F C9            [10]   44 ret
                             45 
                             46 ;;====================================
                             47 ;; Draw the enemy
                             48 ;;====================================
                             49 
   4030                      50 enemy_draw::
   4030 3E F0         [ 7]   51 	ld a, #0xF0							;;enemy Color RED
   4032 CD 7E 40      [17]   52 	call drawEnemy  					;;Draw enemy :D 
                             53 
   4035 C9            [10]   54 ret
                             55 
                             56 ;;====================================
                             57 ;; Draw the enemy
                             58 ;;====================================
   4036                      59 enemy_getX::
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                             60 
   4036 3A 23 40      [13]   61 	ld a, (enemy_x)						;; B = Enemy_X
   4039 C9            [10]   62 ret
                             63 
                             64 
                             65 
                             66 
                             67 ;;####################################
                             68 ;; PRIVATE FUNCTIONS
                             69 ;;####################################
                             70 
                             71 ;;====================================
                             72 ;; Move enemy right-left
                             73 ;; DESTROY: AF
                             74 ;;====================================
                             75 
   403A                      76 updateEnemy:
   403A 3A 23 40      [13]   77 	ld 	a,(enemy_x) 					;; Load Enemy_X
   403D FE 4E         [ 7]   78 	cp 	#80-2 							;; |
   403F 28 08         [12]   79 	jr	z, changeToLeft 				;; if (Enemy_X == 79){ changeToLeft (dirrection = 1) }
   4041 FE 00         [ 7]   80 	cp 	#0 								;; |
   4043 28 0D         [12]   81 	jr	z, changeToRight 				;; else if (Enemy_X == 0) { changeToRight (direcction = 2)}
                             82 
   4045 CD 5B 40      [17]   83 	call moveTo							;; else {move player to direccion}
                             84 
   4048 C9            [10]   85 ret
                             86 
                             87 
                             88 
   4049                      89 changeToLeft: 							
   4049 3E 01         [ 7]   90 	ld 	a, #1 							;; |
   404B 32 25 40      [13]   91 	ld 	(direccion), a 					;; A = 1
   404E CD 5B 40      [17]   92 	call moveTo 						;; Move enemy to direction
   4051 C9            [10]   93 ret
                             94 
                             95 
   4052                      96 changeToRight:
   4052 3E 02         [ 7]   97 	ld 	a, #2 							;; |
   4054 32 25 40      [13]   98 	ld 	(direccion), a 					;; A = 2
   4057 CD 5B 40      [17]   99 	call moveTo 						;; Move Enemy to direction
   405A C9            [10]  100 ret
                            101 
                            102 
   405B                     103 moveTo:
   405B 3A 25 40      [13]  104 	ld 	a, (direccion) 					;; A = direction
   405E FE 01         [ 7]  105 	cp 	#1 								;; |
   4060 28 10         [12]  106 	jr 	z, moveEnemyLeft 				;; if (direction = 1 [LEFT]) {Move Enemy to Left}
   4062 CD 66 40      [17]  107 	call moveEnemyRight					;; else {Move enmey to Right}
                            108 
   4065 C9            [10]  109 ret
                            110 
                            111 
                            112 
                            113 ;;====================================
                            114 ;; Move enemy Right
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                            115 ;; DESTROY: AF
                            116 ;;====================================
   4066                     117 moveEnemyRight:
                            118 
   4066 3A 23 40      [13]  119 	ld a, (enemy_x)					;; A = enemy_x
   4069 FE 4E         [ 7]  120 	cp #80-2							;; Check if A is (limit of screen - enemy width)
   406B 28 04         [12]  121 	jr z, dont_move_r						;; Dont move the enemy
                            122 
   406D 3C            [ 4]  123 		inc a 							;; Else: A++
   406E 32 23 40      [13]  124 		ld (enemy_x), a 				;; enemy_x Update
                            125 
   4071                     126 	dont_move_r:
   4071 C9            [10]  127 ret
                            128 
                            129 
                            130 
                            131 ;;====================================
                            132 ;; Move enemy Left
                            133 ;; DESTROY: AF
                            134 ;;====================================
   4072                     135 moveEnemyLeft:
                            136 
   4072 3A 23 40      [13]  137 	ld a, (enemy_x)					;; A == enemy_x
   4075 FE 00         [ 7]  138 	cp #0								;; Check if enemy (screen rigth limit)
   4077 28 04         [12]  139 	jr z, dont_move_l
                            140 	 
   4079 3D            [ 4]  141 		dec a 							;; Else: A-- (enemy_X--)
   407A 32 23 40      [13]  142 		ld (enemy_x), a 				;; enemy_x Update 
                            143 
   407D                     144 	dont_move_l:
   407D C9            [10]  145 ret
                            146 
                            147 
                            148 
                            149 
                            150 ;;====================================
                            151 ;; Draw enemy
                            152 ;; INPUTS:
                            153 ;; 		A ==> Color Patern
                            154 ;; DESTROY: AF, BC, DE, HL
                            155 ;;====================================
   407E                     156 drawEnemy:
                            157 	
   407E F5            [11]  158 	push af 							;; Save A in Stack
                            159 	;;Calculate scrren position
   407F 11 00 C0      [10]  160 	ld 		de, #0xC000					;;Video Memory Pointer
   4082 3A 23 40      [13]  161 	ld 		 a, (enemy_x)				;;|
   4085 4F            [ 4]  162 	ld 		 c, a 						;; C = enemy_x
   4086 3A 24 40      [13]  163 	ld 		 a, (enemy_y)				;;|
   4089 47            [ 4]  164 	ld 		 b, a 						;; B = enemy_y
   408A CD 88 42      [17]  165 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            166 	
                            167 
                            168 	;; Draw a box
   408D EB            [ 4]  169 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



   408E F1            [10]  170 	pop 	af							;; A = User Selecter Color
   408F 01 01 04      [10]  171 	ld 		bc, 	#0x0401				;; 4x4 pixeles
   4092 CD DB 41      [17]  172 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            173 
   4095 C9            [10]  174 ret
                            175 
                            176 
                            177 
                            178 
                            179 
                            180 
