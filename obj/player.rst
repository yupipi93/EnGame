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
   40D4                      25 _cpct_keyboardStatusBuffer:: .ds 10
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
                              9 .globl cpct_disableFirmware_asm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              5 
                              6 ;;####################################
                              7 ;; PRIVATE DATA
                              8 ;;####################################
                              9 
                             10 
                             11 ;; Player Data
   40DE 27                   12 player_x: 		.db #39
   40DF 50                   13 player_y: 		.db #80
   40E0 02                   14 player_w: 		.db #2 			;;Whidth
   40E1 08                   15 player_h: 		.db #8 			;;Height
                             16 
   40E2 FF                   17 player_jump:	.db #-1
                             18 
                             19 ;; Jump Table
   40E3                      20 jumpTable:
   40E3 FD FE FF FF          21 	.db 	#-3, #-2, #-1, #-1
   40E7 FF 00 00 00          22 	.db 	#-1, #00, #00, #00
   40EB 01 02 02 03          23 	.db 	#01, #02, #02, #03
   40EF 80                   24 	.db 	#0x80
                             25 
   40F0 00                   26 floor_x: 		.db #00
   40F1 58                   27 floor_y:		.db #88
                             28 
                             29 
                             30 
                             31 
                             32 
                             33 
                             34 ;;####################################
                             35 ;; PUBLIC FUNCTIONS ::
                             36 ;;####################################
                             37 
                             38 ;;====================================
                             39 ;; Draw Floor
                             40 ;;====================================
   40F2                      41 draw_floor::
   40F2 CD E6 41      [17]   42  call drawFloor
   40F5 C9            [10]   43 ret
                             44 
                             45 
                             46 ;;====================================
                             47 ;; Erase th Player
                             48 ;;====================================
                             49 
   40F6                      50 player_erase::
   40F6 3E 00         [ 7]   51 	ld a, #0x00							;;Erase Player (Backgrownd Color)
   40F8 CD CE 41      [17]   52 	call drawPlayer 					;;Draw player :D
                             53 
   40FB C9            [10]   54 ret
                             55 
                             56 ;;====================================
                             57 ;; Update the Player
                             58 ;;====================================
                             59 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   40FC                      60 player_update::
   40FC CD 45 41      [17]   61 	call jumpControl 					;;Do Jump
   40FF CD 91 41      [17]   62 	call HandleEvent 					;;Keyboard check
                             63 
   4102 C9            [10]   64 ret
                             65 
                             66 ;;====================================
                             67 ;; Draw the Player
                             68 ;;====================================
                             69 
   4103                      70 player_draw::
   4103 3E FF         [ 7]   71 	ld a, #0xFF							;;Player Color RED
   4105 CD CE 41      [17]   72 	call drawPlayer 					;;Draw player :D 
                             73 
   4108 C9            [10]   74 ret
                             75 
                             76 
                             77 ;;====================================
                             78 ;; Gets a pointer to hero data in HL
                             79 ;; DESTROY: HL
                             80 ;; RETURN: 
                             81 ;; 		HL: Pointer to Player data
                             82 ;;====================================
                             83 
   4109                      84 player_getPtrHL::
   4109 21 DE 40      [10]   85 	ld 	hl, #player_x 					;; HL: pointer to player data
   410C C9            [10]   86 ret
                             87 
                             88 
                             89 
                             90 ;;====================================
                             91 ;; Player Collition
                             92 ;;====================================
                             93 
   410D                      94 player_collition::
                             95 
   410D CD 11 41      [17]   96  	call calculateCollition
   4110 C9            [10]   97 ret
                             98 
                             99 
                            100 
                            101 
                            102 ;;####################################
                            103 ;; PRIVATE FUNCTIONS
                            104 ;;####################################
                            105 
                            106 
                            107 
                            108 ;;====================================
                            109 ;; Collition Inidcator
                            110 ;; DESTROY: 
                            111 ;;====================================
   4111                     112 calculateCollition:
   4111 47            [ 4]  113 	ld 		b,a 						;; B = Enemy_X
   4112 C6 01         [ 7]  114 	add 	a, #1 						;; A = Enemy_X + Width
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   4114 4F            [ 4]  115 	ld 		c, a 						;; C = EX+Enemy_Width (2)
                            116 	
                            117 
   4115 3A DE 40      [13]  118 	ld 		a, (player_x) 				;; |
   4118 5F            [ 4]  119 	ld 		e, a 						;; E = Player_X
   4119 C6 07         [ 7]  120 	add 	a, #7 						;; |
   411B 57            [ 4]  121 	ld 		d, a 						;; D = PX+Player_With (8)
                            122 
                            123 	;;Comprobar si, EX+Enemy_W  esta a la izquierda de Player_X
                            124 
   411C 90            [ 4]  125 	sub 	a,b 						;; |
   411D 28 04         [12]  126 	jr 		z, collitionON				;; if (a==b){collition ON}
   411F CD 29 41      [17]  127 	call collitionOFF					;; else{collitionOFF}
   4122 C9            [10]  128 ret
                            129 
   4123                     130 collitionON:
   4123 3E 0F         [ 7]  131 	ld a, #0x0F							;;Player Color RED
   4125 CD 2F 41      [17]  132 	call drawIndicator 					;;Draw player :D 
   4128 C9            [10]  133 ret
                            134 
   4129                     135 collitionOFF:
   4129 3E 00         [ 7]  136 	ld a, #0x00							;;Player Color RED
   412B CD 2F 41      [17]  137 	call drawIndicator 					;;Draw player :D 
   412E C9            [10]  138 ret
                            139 
                            140 
   412F                     141 drawIndicator:
                            142 	
   412F F5            [11]  143 	push af 							;; Save A in Stack
                            144 	;;Calculate scrren position
   4130 11 00 C0      [10]  145 	ld 		de, #0xC000					;;Video Memory Pointer
   4133 3E 00         [ 7]  146 	ld 		 a, #00				;;|
   4135 4F            [ 4]  147 	ld 		 c, a 						;; C = Player_x
   4136 3E 00         [ 7]  148 	ld 		 a, #00				;;|
   4138 47            [ 4]  149 	ld 		 b, a 						;; B = Player_y
   4139 CD CF 42      [17]  150 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            151 	
                            152 
                            153 	;; Draw a box
   413C EB            [ 4]  154 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   413D F1            [10]  155 	pop 	af							;; A = User Selecter Color
   413E 01 02 08      [10]  156 	ld 		bc, 	#0x0802				;; 8x8 pixeles
   4141 CD 22 42      [17]  157 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            158 
   4144 C9            [10]  159 ret
                            160 
                            161 
                            162 
                            163 
                            164 ;;====================================
                            165 ;; Controls Jump Momevemnts
                            166 ;; DESTROY: 
                            167 ;;====================================
   4145                     168 jumpControl:
   4145 3A E2 40      [13]  169 	ld		 a, (player_jump)			;; A = Player Jump Status
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



   4148 FE FF         [ 7]  170 	cp 		#-1							;; A == -1? (-1 is not jump)
   414A C8            [11]  171 	ret 	z							;; If A == -1, not jumping, so ret
                            172 
                            173 	;; Ger Jumps Values
   414B 21 E3 40      [10]  174 	ld		hl, #jumpTable				;; Load JumpTable Pointer
   414E 06 00         [ 7]  175 	ld 		 b, #0						;; |
   4150 4F            [ 4]  176 	ld 		 c, a 						;; BC = A (Offset)
   4151 09            [11]  177 	add 	hl, bc 						;; HL += BC
                            178 
                            179 	;; Check end jump
   4152 7E            [ 7]  180 	ld 		a, (hl) 					;; A = jump Movement
   4153 FE 80         [ 7]  181 	cp 		#0x80 						;; Jump value == 0
   4155 28 10         [12]  182 	jr 		z, end_of_jump 				;; If 0x80 end of jump
                            183 
                            184 	;; Do Jump Movement
   4157 47            [ 4]  185 	ld 		 b, a						;; B = Fist Position TableJump
   4158 3A DF 40      [13]  186 	ld 		 a, (player_y)				;; A = Player_Y
   415B 80            [ 4]  187 	add 	 b 							;; A += B (Add jump movmenet)
   415C 32 DF 40      [13]  188 	ld 		(player_y), a 				;; Update Hero_Y value
                            189 
                            190 	;; Increase Player_jump Index
   415F 3A E2 40      [13]  191 	ld 		a, (player_jump) 			;; A = Player_jump
   4162 3C            [ 4]  192 	inc 	a 							;; |
   4163 32 E2 40      [13]  193 	ld 		(player_jump), a 			;; Player_jump++
                            194 
                            195 
   4166 C9            [10]  196 ret
                            197 
                            198 ;; Put -1 in jump status
   4167                     199 end_of_jump:
   4167 3E FF         [ 7]  200 	ld 		a, #-1 						;; |
   4169 32 E2 40      [13]  201 	ld 		(player_jump),a 			;; Player_jump = -1
   416C C9            [10]  202 ret
                            203 
                            204 ;;====================================
                            205 ;; Start Player Jump
                            206 ;; DESTROY: AF
                            207 ;;====================================
   416D                     208 startJump:
                            209 
   416D 3A E2 40      [13]  210 	ld 	a, (player_jump)				;; A = Player_jump
   4170 FE FF         [ 7]  211 	cp 	#-1 							;; A == -1?  Jump is active?	
   4172 C0            [11]  212 	ret nz 								;; Jump Active, return
                            213 
                            214 	;; Jump is Inactive, Active it!
   4173 3E 00         [ 7]  215 	ld 	a, #0 							 
   4175 32 E2 40      [13]  216 	ld (player_jump), a 
   4178 C9            [10]  217 ret
                            218 
                            219 
                            220 
                            221 ;;====================================
                            222 ;; Move Player Right
                            223 ;; DESTROY: AF
                            224 ;;====================================
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   4179                     225 movePlayerRight:
                            226 
   4179 3A DE 40      [13]  227 	ld a, (player_x)					;; A = Player_x
   417C FE 4E         [ 7]  228 	cp #80-2							;; Check if A is (limit of screen - player width)
   417E 28 04         [12]  229 	jr z, dont_move_r						;; Dont move the player
                            230 
   4180 3C            [ 4]  231 		inc a 							;; Else: A++
   4181 32 DE 40      [13]  232 		ld (player_x), a 				;; Player_x Update
                            233 
   4184                     234 	dont_move_r:
   4184 C9            [10]  235 ret
                            236 
                            237 
                            238 
                            239 ;;====================================
                            240 ;; Move Player Left
                            241 ;; DESTROY: AF
                            242 ;;====================================
   4185                     243 movePlayerLeft:
                            244 
   4185 3A DE 40      [13]  245 	ld a, (player_x)					;; A == Player_x
   4188 FE 00         [ 7]  246 	cp #0								;; Check if player (screen rigth limit)
   418A 28 04         [12]  247 	jr z, dont_move_l
                            248 	 
   418C 3D            [ 4]  249 		dec a 							;; Else: A-- (Player_X--)
   418D 32 DE 40      [13]  250 		ld (player_x), a 				;; Player_x Update 
                            251 
   4190                     252 	dont_move_l:
   4190 C9            [10]  253 ret
                            254 
                            255 ;;====================================
                            256 ;; Handle Events
                            257 ;; DESTROY: AF, BC, DE, HL
                            258 ;;====================================
   4191                     259 HandleEvent:
   4191 CD 9A 41      [17]  260 	call check_KeyD_pressed
   4194 CD AB 41      [17]  261 	call check_KeyA_pressed
   4197 CD BC 41      [17]  262 	call check_KeyW_pressed
                            263 	
   419A                     264 		check_KeyD_pressed:
   419A CD EB 42      [17]  265 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   419D 21 07 20      [10]  266 			ld hl, #Key_D 						;; HL = KEY 'D' Code
   41A0 CD FE 41      [17]  267 			call cpct_isKeyPressed_asm			;; Check for key 'D' is presed
   41A3 FE 00         [ 7]  268 			cp #0 								;; Check A == 0
   41A5 28 03         [12]  269 			jr z, d_not_pressed					;; Jump if A == 0 ('D' not pressed)
                            270 				
   41A7 CD 79 41      [17]  271 				call movePlayerRight			;; 'D' is pressed
                            272 		
   41AA                     273 			d_not_pressed:						;; Do nothing
                            274 		
   41AA C9            [10]  275 		ret
                            276 
   41AB                     277 		check_KeyA_pressed:
   41AB CD EB 42      [17]  278 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   41AE 21 08 20      [10]  279 			ld hl, #Key_A 						;; HL = KEY 'A' Code
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   41B1 CD FE 41      [17]  280 			call cpct_isKeyPressed_asm			;; Check for key 'A' is presed
   41B4 FE 00         [ 7]  281 			cp #0 								;; Check A == 0
   41B6 28 03         [12]  282 			jr z, a_not_pressed					;; Jump if A == 0 ('A' not pressed)
                            283 		
   41B8 CD 85 41      [17]  284 				call movePlayerLeft				;; 'A' is pressed
                            285 		
   41BB                     286 			a_not_pressed:						;; Do nothing
                            287 
   41BB C9            [10]  288 		ret
                            289 
   41BC                     290 		check_KeyW_pressed:
   41BC CD EB 42      [17]  291 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   41BF 21 07 08      [10]  292 			ld hl, #Key_W 						;; HL = KEY 'W' Code
   41C2 CD FE 41      [17]  293 			call cpct_isKeyPressed_asm			;; Check for key 'W' is presed
   41C5 FE 00         [ 7]  294 			cp #0 								;; Check A == 0
   41C7 28 03         [12]  295 			jr z, w_not_pressed					;; Jump if A == 0 ('W' not pressed)
                            296 		
   41C9 CD 6D 41      [17]  297 				call startJump					;; 'W' is pressed
                            298 		
   41CC                     299 			w_not_pressed:						;; Do nothing
                            300 
   41CC C9            [10]  301 		ret
                            302 
                            303 
   41CD C9            [10]  304 ret
                            305 ;;====================================
                            306 ;; Draw Player
                            307 ;; INPUTS:
                            308 ;; 		A ==> Color Patern
                            309 ;; DESTROY: AF, BC, DE, HL
                            310 ;;====================================
   41CE                     311 drawPlayer:
                            312 	
   41CE F5            [11]  313 	push af 							;; Save A in Stack
                            314 	;;Calculate scrren position
   41CF 11 00 C0      [10]  315 	ld 		de, #0xC000					;;Video Memory Pointer
   41D2 3A DE 40      [13]  316 	ld 		 a, (player_x)				;;|
   41D5 4F            [ 4]  317 	ld 		 c, a 						;; C = Player_x
   41D6 3A DF 40      [13]  318 	ld 		 a, (player_y)				;;|
   41D9 47            [ 4]  319 	ld 		 b, a 						;; B = Player_y
   41DA CD CF 42      [17]  320 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            321 	
                            322 
                            323 	;; Draw a box
   41DD EB            [ 4]  324 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   41DE F1            [10]  325 	pop 	af							;; A = User Selecter Color
   41DF 01 02 08      [10]  326 	ld 		bc, 	#0x0802				;; 8x8 pixeles
   41E2 CD 22 42      [17]  327 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            328 
   41E5 C9            [10]  329 ret
                            330 
                            331 
                            332 ;;====================================
                            333 ;; Draw Floor
                            334 ;; DESTROY: AF, BC, DE, HL
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



                            335 ;;====================================
   41E6                     336 drawFloor:
                            337 	;;Screen Pointer
   41E6 11 00 C0      [10]  338 	ld 		de, #0xC000					;;Video Memory Pointer
   41E9 3A F0 40      [13]  339 	ld 		 a, (floor_x)				;;|
   41EC 4F            [ 4]  340 	ld 		 c, a 						;; C = Floor_X
   41ED 3A F1 40      [13]  341 	ld		 a, (floor_y)				;;|
   41F0 47            [ 4]  342 	ld		 b, a 						;; B = Floor_Y
   41F1 CD CF 42      [17]  343 	call 	cpct_getScreenPtr_asm 		;; Get Pointer to Screen (return to HL)
                            344 	
                            345 	;; Draw a Floor
   41F4 EB            [ 4]  346 	ex		de, hl 						;; Change DE <==> HL (Screen pointer)
   41F5 3E F0         [ 7]  347 	ld		 a, #0xF0					;; Select Color (F0 ==> Yellow)
   41F7 01 40 64      [10]  348 	ld 		bc, #0x6440					;; ?x? pixel width
   41FA CD 22 42      [17]  349 	call 	cpct_drawSolidBox_asm
                            350 
   41FD C9            [10]  351 ret
                            352 
                            353 
                            354 
                            355 
