ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .area _CODE 
                              2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              3 .include "keyboard/keyboard.s"
                              1 ;;-----------------------------LICENSE NOTICE------------------------------------
                              2 ;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
                              3 ;;  Copyright (C) 2014 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
                              4 ;;
                              5 ;;  This program is free software: you can redistribute it and/or modify
                              6 ;;  it under the terms of the GNU Lesser General Public License as published by
                              7 ;;  the Free Software Foundation, either version 3 of the License, or
                              8 ;;  (at your option) any later version.
                              9 ;;
                             10 ;;  This program is distributed in the hope that it will be useful,
                             11 ;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
                             12 ;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                             13 ;;  GNU Lesser General Public License for more details.
                             14 ;;
                             15 ;;  You should have received a copy of the GNU Lesser General Public License
                             16 ;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
                             17 ;;-------------------------------------------------------------------------------
                             18 .module cpct_keyboard
                             19 
                             20 ;; bndry directive does not work when linking previously compiled files
                             21 ;.bndry 16
                             22 ;;   16-byte aligned in memory to let functions use 8-bit maths for pointing
                             23 ;;   (alignment not working on user linking)
                             24 
   4096                      25 _cpct_keyboardStatusBuffer:: .ds 10
                             26 
                             27 ;;
                             28 ;; Assembly constant definitions for keyboard mapping
                             29 ;;
                             30 
                             31 ;; Matrix Line 0x00
                     0100    32 .equ Key_CursorUp     ,#0x0100  ;; Bit 0 (01h) => | 0000 0001 |
                     0200    33 .equ Key_CursorRight  ,#0x0200  ;; Bit 1 (02h) => | 0000 0010 |
                     0400    34 .equ Key_CursorDown   ,#0x0400  ;; Bit 2 (04h) => | 0000 0100 |
                     0800    35 .equ Key_F9           ,#0x0800  ;; Bit 3 (08h) => | 0000 1000 |
                     1000    36 .equ Key_F6           ,#0x1000  ;; Bit 4 (10h) => | 0001 0000 |
                     2000    37 .equ Key_F3           ,#0x2000  ;; Bit 5 (20h) => | 0010 0000 |
                     4000    38 .equ Key_Enter        ,#0x4000  ;; Bit 6 (40h) => | 0100 0000 |
                     8000    39 .equ Key_FDot         ,#0x8000  ;; Bit 7 (80h) => | 1000 0000 |
                             40 ;; Matrix Line 0x01
                     0101    41 .equ Key_CursorLeft   ,#0x0101
                     0201    42 .equ Key_Copy         ,#0x0201
                     0401    43 .equ Key_F7           ,#0x0401
                     0801    44 .equ Key_F8           ,#0x0801
                     1001    45 .equ Key_F5           ,#0x1001
                     2001    46 .equ Key_F1           ,#0x2001
                     4001    47 .equ Key_F2           ,#0x4001
                     8001    48 .equ Key_F0           ,#0x8001
                             49 ;; Matrix Line 0x02
                     0102    50 .equ Key_Clr          ,#0x0102
                     0202    51 .equ Key_OpenBracket  ,#0x0202
                     0402    52 .equ Key_Return       ,#0x0402
                     0802    53 .equ Key_CloseBracket ,#0x0802
                     1002    54 .equ Key_F4           ,#0x1002
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                     2002    55 .equ Key_Shift        ,#0x2002
                     4002    56 .equ Key_BackSlash    ,#0x4002
                     8002    57 .equ Key_Control      ,#0x8002
                             58 ;; Matrix Line 0x03
                     0103    59 .equ Key_Caret        ,#0x0103
                     0203    60 .equ Key_Hyphen       ,#0x0203
                     0403    61 .equ Key_At           ,#0x0403
                     0803    62 .equ Key_P            ,#0x0803
                     1003    63 .equ Key_SemiColon    ,#0x1003
                     2003    64 .equ Key_Colon        ,#0x2003
                     4003    65 .equ Key_Slash        ,#0x4003
                     8003    66 .equ Key_Dot          ,#0x8003
                             67 ;; Matrix Line 0x04
                     0104    68 .equ Key_0            ,#0x0104
                     0204    69 .equ Key_9            ,#0x0204
                     0404    70 .equ Key_O            ,#0x0404
                     0804    71 .equ Key_I            ,#0x0804
                     1004    72 .equ Key_L            ,#0x1004
                     2004    73 .equ Key_K            ,#0x2004
                     4004    74 .equ Key_M            ,#0x4004
                     8004    75 .equ Key_Comma        ,#0x8004
                             76 ;; Matrix Line 0x05
                     0105    77 .equ Key_8            ,#0x0105
                     0205    78 .equ Key_7            ,#0x0205
                     0405    79 .equ Key_U            ,#0x0405
                     0805    80 .equ Key_Y            ,#0x0805
                     1005    81 .equ Key_H            ,#0x1005
                     2005    82 .equ Key_J            ,#0x2005
                     4005    83 .equ Key_N            ,#0x4005
                     8005    84 .equ Key_Space        ,#0x8005
                             85 ;; Matrix Line 0x06
                     0106    86 .equ Key_6            ,#0x0106
                     0106    87 .equ Joy1_Up          ,#0x0106
                     0206    88 .equ Key_5            ,#0x0206
                     0206    89 .equ Joy1_Down        ,#0x0206
                     0406    90 .equ Key_R            ,#0x0406
                     0406    91 .equ Joy1_Left        ,#0x0406
                     0806    92 .equ Key_T            ,#0x0806
                     0806    93 .equ Joy1_Right       ,#0x0806
                     1006    94 .equ Key_G            ,#0x1006
                     1006    95 .equ Joy1_Fire1       ,#0x1006
                     2006    96 .equ Key_F            ,#0x2006
                     2006    97 .equ Joy1_Fire2       ,#0x2006
                     4006    98 .equ Key_B            ,#0x4006
                     4006    99 .equ Joy1_Fire3       ,#0x4006
                     8006   100 .equ Key_V            ,#0x8006
                            101 ;; Matrix Line 0x07
                     0107   102 .equ Key_4            ,#0x0107
                     0207   103 .equ Key_3            ,#0x0207
                     0407   104 .equ Key_E            ,#0x0407
                     0807   105 .equ Key_W            ,#0x0807
                     1007   106 .equ Key_S            ,#0x1007
                     2007   107 .equ Key_D            ,#0x2007
                     4007   108 .equ Key_C            ,#0x4007
                     8007   109 .equ Key_X            ,#0x8007
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                            110 ;; Matrix Line 0x08
                     0108   111 .equ Key_1            ,#0x0108
                     0208   112 .equ Key_2            ,#0x0208
                     0408   113 .equ Key_Esc          ,#0x0408
                     0808   114 .equ Key_Q            ,#0x0808
                     1008   115 .equ Key_Tab          ,#0x1008
                     2008   116 .equ Key_A            ,#0x2008
                     4008   117 .equ Key_CapsLock     ,#0x4008
                     8008   118 .equ Key_Z            ,#0x8008
                            119 ;; Matrix Line 0x09
                     0109   120 .equ Joy0_Up          ,#0x0109
                     0209   121 .equ Joy0_Down        ,#0x0209
                     0409   122 .equ Joy0_Left        ,#0x0409
                     0809   123 .equ Joy0_Right       ,#0x0809
                     1009   124 .equ Joy0_Fire1       ,#0x1009
                     2009   125 .equ Joy0_Fire2       ,#0x2009
                     4009   126 .equ Joy0_Fire3       ,#0x4009
                     8009   127 .equ Key_Del          ,#0x8009
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              5 
                              6 ;;####################################
                              7 ;; PRIVATE DATA
                              8 ;;####################################
                              9 
                             10 
                             11 ;; Player Data
   40A0 27                   12 player_x: 		.db #39
   40A1 50                   13 player_y: 		.db #80
   40A2 FF                   14 player_jump:	.db #-1
                             15 
                             16 ;; Jump Table
   40A3                      17 jumpTable:
   40A3 FD FE FF FF          18 	.db 	#-3, #-2, #-1, #-1
   40A7 FF 00 00 00          19 	.db 	#-1, #00, #00, #00
   40AB 01 02 02 03          20 	.db 	#01, #02, #02, #03
   40AF 80                   21 	.db 	#0x80
                             22 
   40B0 00                   23 floor_x: 		.db #00
   40B1 58                   24 floor_y:		.db #88
                             25 
                             26 
                             27 
                             28 
                             29 
                             30 
                             31 ;;####################################
                             32 ;; PUBLIC FUNCTIONS ::
                             33 ;;####################################
                             34 
                             35 ;;====================================
                             36 ;; Draw Floor
                             37 ;;====================================
   40B2                      38 draw_floor::
   40B2 CD 9F 41      [17]   39  call drawFloor
   40B5 C9            [10]   40 ret
                             41 
                             42 
                             43 ;;====================================
                             44 ;; Erase th Player
                             45 ;;====================================
                             46 
   40B6                      47 player_erase::
   40B6 3E 00         [ 7]   48 	ld a, #0x00							;;Erase Player (Backgrownd Color)
   40B8 CD 87 41      [17]   49 	call drawPlayer 					;;Draw player :D
                             50 
   40BB C9            [10]   51 ret
                             52 
                             53 ;;====================================
                             54 ;; Update the Player
                             55 ;;====================================
                             56 
   40BC                      57 player_update::
   40BC CD FE 40      [17]   58 	call jumpControl 					;;Do Jump
   40BF CD 4A 41      [17]   59 	call HandleEvent 					;;Keyboard check
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                             60 
   40C2 C9            [10]   61 ret
                             62 
                             63 ;;====================================
                             64 ;; Draw the Player
                             65 ;;====================================
                             66 
   40C3                      67 player_draw::
   40C3 3E FF         [ 7]   68 	ld a, #0xFF							;;Player Color RED
   40C5 CD 87 41      [17]   69 	call drawPlayer 					;;Draw player :D 
                             70 
   40C8 C9            [10]   71 ret
                             72 
                             73 
                             74 ;;====================================
                             75 ;; Player Collition
                             76 ;;====================================
                             77 
   40C9                      78 player_collition::
                             79 
   40C9 CD CD 40      [17]   80  	call calculateCollition
   40CC C9            [10]   81 ret
                             82 
                             83 
                             84 
                             85 
                             86 ;;####################################
                             87 ;; PRIVATE FUNCTIONS
                             88 ;;####################################
                             89 
                             90 
                             91 
                             92 ;;====================================
                             93 ;; Collition Inidcator
                             94 ;; DESTROY: 
                             95 ;;====================================
   40CD                      96 calculateCollition:
   40CD 47            [ 4]   97 	ld 		b,a 						;; B = Enemy_X
   40CE 0E 01         [ 7]   98 	ld 		c, #1 						;; C = Enemy_Width (2)
                             99 
   40D0 3A A0 40      [13]  100 	ld 		a, (player_x) 				;; A = Player_X
   40D3 16 07         [ 7]  101 	ld 		d, #7 						;; D = Player_With (2)
                            102 
                            103 	;;comprobar si, Enemy es
                            104 
   40D5 90            [ 4]  105 	sub 	a,b 						;; |
   40D6 28 04         [12]  106 	jr 		z, collitionON				;; if (a==b){collition ON}
   40D8 CD E2 40      [17]  107 	call collitionOFF					;; else{collitionOFF}
   40DB C9            [10]  108 ret
                            109 
   40DC                     110 collitionON:
   40DC 3E 0F         [ 7]  111 	ld a, #0x0F							;;Player Color RED
   40DE CD E8 40      [17]  112 	call drawIndicator 					;;Draw player :D 
   40E1 C9            [10]  113 ret
                            114 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   40E2                     115 collitionOFF:
   40E2 3E 00         [ 7]  116 	ld a, #0x00							;;Player Color RED
   40E4 CD E8 40      [17]  117 	call drawIndicator 					;;Draw player :D 
   40E7 C9            [10]  118 ret
                            119 
                            120 
   40E8                     121 drawIndicator:
                            122 	
   40E8 F5            [11]  123 	push af 							;; Save A in Stack
                            124 	;;Calculate scrren position
   40E9 11 00 C0      [10]  125 	ld 		de, #0xC000					;;Video Memory Pointer
   40EC 3E 00         [ 7]  126 	ld 		 a, #00				;;|
   40EE 4F            [ 4]  127 	ld 		 c, a 						;; C = Player_x
   40EF 3E 00         [ 7]  128 	ld 		 a, #00				;;|
   40F1 47            [ 4]  129 	ld 		 b, a 						;; B = Player_y
   40F2 CD 88 42      [17]  130 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            131 	
                            132 
                            133 	;; Draw a box
   40F5 EB            [ 4]  134 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   40F6 F1            [10]  135 	pop 	af							;; A = User Selecter Color
   40F7 01 02 08      [10]  136 	ld 		bc, 	#0x0802				;; 8x8 pixeles
   40FA CD DB 41      [17]  137 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            138 
   40FD C9            [10]  139 ret
                            140 
                            141 
                            142 
                            143 
                            144 ;;====================================
                            145 ;; Controls Jump Momevemnts
                            146 ;; DESTROY: 
                            147 ;;====================================
   40FE                     148 jumpControl:
   40FE 3A A2 40      [13]  149 	ld		 a, (player_jump)			;; A = Player Jump Status
   4101 FE FF         [ 7]  150 	cp 		#-1							;; A == -1? (-1 is not jump)
   4103 C8            [11]  151 	ret 	z							;; If A == -1, not jumping, so ret
                            152 
                            153 	;; Ger Jumps Values
   4104 21 A3 40      [10]  154 	ld		hl, #jumpTable				;; Load JumpTable Pointer
   4107 06 00         [ 7]  155 	ld 		 b, #0						;; |
   4109 4F            [ 4]  156 	ld 		 c, a 						;; BC = A (Offset)
   410A 09            [11]  157 	add 	hl, bc 						;; HL += BC
                            158 
                            159 	;; Check end jump
   410B 7E            [ 7]  160 	ld 		a, (hl) 					;; A = jump Movement
   410C FE 80         [ 7]  161 	cp 		#0x80 						;; Jump value == 0
   410E 28 10         [12]  162 	jr 		z, end_of_jump 				;; If 0x80 end of jump
                            163 
                            164 	;; Do Jump Movement
   4110 47            [ 4]  165 	ld 		 b, a						;; B = Fist Position TableJump
   4111 3A A1 40      [13]  166 	ld 		 a, (player_y)				;; A = Player_Y
   4114 80            [ 4]  167 	add 	 b 							;; A += B (Add jump movmenet)
   4115 32 A1 40      [13]  168 	ld 		(player_y), a 				;; Update Hero_Y value
                            169 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                            170 	;; Increase Player_jump Index
   4118 3A A2 40      [13]  171 	ld 		a, (player_jump) 			;; A = Player_jump
   411B 3C            [ 4]  172 	inc 	a 							;; |
   411C 32 A2 40      [13]  173 	ld 		(player_jump), a 			;; Player_jump++
                            174 
                            175 
   411F C9            [10]  176 ret
                            177 
                            178 ;; Put -1 in jump status
   4120                     179 end_of_jump:
   4120 3E FF         [ 7]  180 	ld 		a, #-1 						;; |
   4122 32 A2 40      [13]  181 	ld 		(player_jump),a 			;; Player_jump = -1
   4125 C9            [10]  182 ret
                            183 
                            184 ;;====================================
                            185 ;; Start Player Jump
                            186 ;; DESTROY: AF
                            187 ;;====================================
   4126                     188 startJump:
                            189 
   4126 3A A2 40      [13]  190 	ld 	a, (player_jump)				;; A = Player_jump
   4129 FE FF         [ 7]  191 	cp 	#-1 							;; A == -1?  Jump is active?	
   412B C0            [11]  192 	ret nz 								;; Jump Active, return
                            193 
                            194 	;; Jump is Inactive, Active it!
   412C 3E 00         [ 7]  195 	ld 	a, #0 							 
   412E 32 A2 40      [13]  196 	ld (player_jump), a 
   4131 C9            [10]  197 ret
                            198 
                            199 
                            200 
                            201 ;;====================================
                            202 ;; Move Player Right
                            203 ;; DESTROY: AF
                            204 ;;====================================
   4132                     205 movePlayerRight:
                            206 
   4132 3A A0 40      [13]  207 	ld a, (player_x)					;; A = Player_x
   4135 FE 4E         [ 7]  208 	cp #80-2							;; Check if A is (limit of screen - player width)
   4137 28 04         [12]  209 	jr z, dont_move_r						;; Dont move the player
                            210 
   4139 3C            [ 4]  211 		inc a 							;; Else: A++
   413A 32 A0 40      [13]  212 		ld (player_x), a 				;; Player_x Update
                            213 
   413D                     214 	dont_move_r:
   413D C9            [10]  215 ret
                            216 
                            217 
                            218 
                            219 ;;====================================
                            220 ;; Move Player Left
                            221 ;; DESTROY: AF
                            222 ;;====================================
   413E                     223 movePlayerLeft:
                            224 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   413E 3A A0 40      [13]  225 	ld a, (player_x)					;; A == Player_x
   4141 FE 00         [ 7]  226 	cp #0								;; Check if player (screen rigth limit)
   4143 28 04         [12]  227 	jr z, dont_move_l
                            228 	 
   4145 3D            [ 4]  229 		dec a 							;; Else: A-- (Player_X--)
   4146 32 A0 40      [13]  230 		ld (player_x), a 				;; Player_x Update 
                            231 
   4149                     232 	dont_move_l:
   4149 C9            [10]  233 ret
                            234 
                            235 ;;====================================
                            236 ;; Handle Events
                            237 ;; DESTROY: AF, BC, DE, HL
                            238 ;;====================================
   414A                     239 HandleEvent:
   414A CD 53 41      [17]  240 	call check_KeyD_pressed
   414D CD 64 41      [17]  241 	call check_KeyA_pressed
   4150 CD 75 41      [17]  242 	call check_KeyW_pressed
                            243 	
   4153                     244 		check_KeyD_pressed:
   4153 CD A4 42      [17]  245 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   4156 21 07 20      [10]  246 			ld hl, #Key_D 						;; HL = KEY 'D' Code
   4159 CD B7 41      [17]  247 			call cpct_isKeyPressed_asm			;; Check for key 'D' is presed
   415C FE 00         [ 7]  248 			cp #0 								;; Check A == 0
   415E 28 03         [12]  249 			jr z, d_not_pressed					;; Jump if A == 0 ('D' not pressed)
                            250 				
   4160 CD 32 41      [17]  251 				call movePlayerRight			;; 'D' is pressed
                            252 		
   4163                     253 			d_not_pressed:						;; Do nothing
                            254 		
   4163 C9            [10]  255 		ret
                            256 
   4164                     257 		check_KeyA_pressed:
   4164 CD A4 42      [17]  258 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   4167 21 08 20      [10]  259 			ld hl, #Key_A 						;; HL = KEY 'A' Code
   416A CD B7 41      [17]  260 			call cpct_isKeyPressed_asm			;; Check for key 'A' is presed
   416D FE 00         [ 7]  261 			cp #0 								;; Check A == 0
   416F 28 03         [12]  262 			jr z, a_not_pressed					;; Jump if A == 0 ('A' not pressed)
                            263 		
   4171 CD 3E 41      [17]  264 				call movePlayerLeft				;; 'A' is pressed
                            265 		
   4174                     266 			a_not_pressed:						;; Do nothing
                            267 
   4174 C9            [10]  268 		ret
                            269 
   4175                     270 		check_KeyW_pressed:
   4175 CD A4 42      [17]  271 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   4178 21 07 08      [10]  272 			ld hl, #Key_W 						;; HL = KEY 'W' Code
   417B CD B7 41      [17]  273 			call cpct_isKeyPressed_asm			;; Check for key 'W' is presed
   417E FE 00         [ 7]  274 			cp #0 								;; Check A == 0
   4180 28 03         [12]  275 			jr z, w_not_pressed					;; Jump if A == 0 ('W' not pressed)
                            276 		
   4182 CD 26 41      [17]  277 				call startJump					;; 'W' is pressed
                            278 		
   4185                     279 			w_not_pressed:						;; Do nothing
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



                            280 
   4185 C9            [10]  281 		ret
                            282 
                            283 
   4186 C9            [10]  284 ret
                            285 ;;====================================
                            286 ;; Draw Player
                            287 ;; INPUTS:
                            288 ;; 		A ==> Color Patern
                            289 ;; DESTROY: AF, BC, DE, HL
                            290 ;;====================================
   4187                     291 drawPlayer:
                            292 	
   4187 F5            [11]  293 	push af 							;; Save A in Stack
                            294 	;;Calculate scrren position
   4188 11 00 C0      [10]  295 	ld 		de, #0xC000					;;Video Memory Pointer
   418B 3A A0 40      [13]  296 	ld 		 a, (player_x)				;;|
   418E 4F            [ 4]  297 	ld 		 c, a 						;; C = Player_x
   418F 3A A1 40      [13]  298 	ld 		 a, (player_y)				;;|
   4192 47            [ 4]  299 	ld 		 b, a 						;; B = Player_y
   4193 CD 88 42      [17]  300 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            301 	
                            302 
                            303 	;; Draw a box
   4196 EB            [ 4]  304 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   4197 F1            [10]  305 	pop 	af							;; A = User Selecter Color
   4198 01 02 08      [10]  306 	ld 		bc, 	#0x0802				;; 8x8 pixeles
   419B CD DB 41      [17]  307 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            308 
   419E C9            [10]  309 ret
                            310 
                            311 
                            312 ;;====================================
                            313 ;; Draw Floor
                            314 ;; DESTROY: AF, BC, DE, HL
                            315 ;;====================================
   419F                     316 drawFloor:
                            317 	;;Screen Pointer
   419F 11 00 C0      [10]  318 	ld 		de, #0xC000					;;Video Memory Pointer
   41A2 3A B0 40      [13]  319 	ld 		 a, (floor_x)				;;|
   41A5 4F            [ 4]  320 	ld 		 c, a 						;; C = Floor_X
   41A6 3A B1 40      [13]  321 	ld		 a, (floor_y)				;;|
   41A9 47            [ 4]  322 	ld		 b, a 						;; B = Floor_Y
   41AA CD 88 42      [17]  323 	call 	cpct_getScreenPtr_asm 		;; Get Pointer to Screen (return to HL)
                            324 	
                            325 	;; Draw a Floor
   41AD EB            [ 4]  326 	ex		de, hl 						;; Change DE <==> HL (Screen pointer)
   41AE 3E F0         [ 7]  327 	ld		 a, #0xF0					;; Select Color (F0 ==> Yellow)
   41B0 01 40 64      [10]  328 	ld 		bc, #0x6440					;; ?x? pixel width
   41B3 CD DB 41      [17]  329 	call 	cpct_drawSolidBox_asm
                            330 
   41B6 C9            [10]  331 ret
                            332 
                            333 
                            334 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



                            335 
