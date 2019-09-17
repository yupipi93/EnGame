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
   4151                      25 _cpct_keyboardStatusBuffer:: .ds 10
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
   415B 27                   12 player_x: 		.db #39
   415C 50                   13 player_y: 		.db #80
   415D 02                   14 player_w: 		.db #2 			;;Whidth
   415E 08                   15 player_h: 		.db #8 			;;Height
                             16 
   415F FF                   17 player_jump:	.db #-1
                             18 
                             19 ;; Jump Table
   4160                      20 jumpTable:
   4160 FD FE FF FF          21 	.db 	#-3, #-2, #-1, #-1
   4164 FF 00 00 00          22 	.db 	#-1, #00, #00, #00
   4168 01 02 02 03          23 	.db 	#01, #02, #02, #03
   416C 80                   24 	.db 	#0x80
                             25 
   416D 00                   26 floor_x: 		.db #00
   416E 58                   27 floor_y:		.db #88
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
                             38 
                             39 ;;====================================
                             40 ;; Erase th Player
                             41 ;;====================================
                             42 
   416F                      43 player_erase::
   416F 3E 00         [ 7]   44 	ld a, #0x00							;;Erase Player (Backgrownd Color)
   4171 CD 0F 42      [17]   45 	call drawPlayer 					;;Draw player :D
                             46 
   4174 C9            [10]   47 ret
                             48 
                             49 ;;====================================
                             50 ;; Update the Player
                             51 ;;====================================
                             52 
   4175                      53 player_update::
   4175 CD 86 41      [17]   54 	call jumpControl 					;;Do Jump
   4178 CD D2 41      [17]   55 	call HandleEvent 					;;Keyboard check
                             56 
   417B C9            [10]   57 ret
                             58 
                             59 ;;====================================
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                             60 ;; Draw the Player
                             61 ;;====================================
                             62 
   417C                      63 player_draw::
   417C 3E FF         [ 7]   64 	ld a, #0xFF							;;Player Color RED
   417E CD 0F 42      [17]   65 	call drawPlayer 					;;Draw player :D 
                             66 
   4181 C9            [10]   67 ret
                             68 
                             69 
                             70 ;;====================================
                             71 ;; Gets a pointer to Player data in HL
                             72 ;; DESTROY: HL
                             73 ;; RETURN: 
                             74 ;; 		HL: Pointer to Player data
                             75 ;;====================================
                             76 
   4182                      77 player_getPtrHL::
   4182 21 5B 41      [10]   78 	ld 	hl, #player_x 					;; HL: pointer to player data
   4185 C9            [10]   79 ret
                             80 
                             81 
                             82 
                             83 
                             84 
                             85 ;;####################################
                             86 ;; PRIVATE FUNCTIONS
                             87 ;;####################################
                             88 
                             89 
                             90 
                             91 
                             92 
                             93 ;;====================================
                             94 ;; Controls Jump Momevemnts
                             95 ;; DESTROY: 
                             96 ;;====================================
   4186                      97 jumpControl:
   4186 3A 5F 41      [13]   98 	ld		 a, (player_jump)			;; A = Player Jump Status
   4189 FE FF         [ 7]   99 	cp 		#-1							;; A == -1? (-1 is not jump)
   418B C8            [11]  100 	ret 	z							;; If A == -1, not jumping, so ret
                            101 
                            102 	;; Ger Jumps Values
   418C 21 60 41      [10]  103 	ld		hl, #jumpTable				;; Load JumpTable Pointer
   418F 06 00         [ 7]  104 	ld 		 b, #0						;; |
   4191 4F            [ 4]  105 	ld 		 c, a 						;; BC = A (Offset)
   4192 09            [11]  106 	add 	hl, bc 						;; HL += BC
                            107 
                            108 	;; Check end jump
   4193 7E            [ 7]  109 	ld 		a, (hl) 					;; A = jump Movement
   4194 FE 80         [ 7]  110 	cp 		#0x80 						;; Jump value == 0
   4196 28 10         [12]  111 	jr 		z, end_of_jump 				;; If 0x80 end of jump
                            112 
                            113 	;; Do Jump Movement
   4198 47            [ 4]  114 	ld 		 b, a						;; B = Fist Position TableJump
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   4199 3A 5C 41      [13]  115 	ld 		 a, (player_y)				;; A = Player_Y
   419C 80            [ 4]  116 	add 	 b 							;; A += B (Add jump movmenet)
   419D 32 5C 41      [13]  117 	ld 		(player_y), a 				;; Update Hero_Y value
                            118 
                            119 	;; Increase Player_jump Index
   41A0 3A 5F 41      [13]  120 	ld 		a, (player_jump) 			;; A = Player_jump
   41A3 3C            [ 4]  121 	inc 	a 							;; |
   41A4 32 5F 41      [13]  122 	ld 		(player_jump), a 			;; Player_jump++
                            123 
                            124 
   41A7 C9            [10]  125 ret
                            126 
                            127 ;; Put -1 in jump status
   41A8                     128 end_of_jump:
   41A8 3E FF         [ 7]  129 	ld 		a, #-1 						;; |
   41AA 32 5F 41      [13]  130 	ld 		(player_jump),a 			;; Player_jump = -1
   41AD C9            [10]  131 ret
                            132 
                            133 ;;====================================
                            134 ;; Start Player Jump
                            135 ;; DESTROY: AF
                            136 ;;====================================
   41AE                     137 startJump:
                            138 
   41AE 3A 5F 41      [13]  139 	ld 	a, (player_jump)				;; A = Player_jump
   41B1 FE FF         [ 7]  140 	cp 	#-1 							;; A == -1?  Jump is active?	
   41B3 C0            [11]  141 	ret nz 								;; Jump Active, return
                            142 
                            143 	;; Jump is Inactive, Active it!
   41B4 3E 00         [ 7]  144 	ld 	a, #0 							 
   41B6 32 5F 41      [13]  145 	ld (player_jump), a 
   41B9 C9            [10]  146 ret
                            147 
                            148 
                            149 
                            150 ;;====================================
                            151 ;; Move Player Right
                            152 ;; DESTROY: AF
                            153 ;;====================================
   41BA                     154 movePlayerRight:
                            155 
   41BA 3A 5B 41      [13]  156 	ld a, (player_x)					;; A = Player_x
   41BD FE 4E         [ 7]  157 	cp #80-2							;; Check if A is (limit of screen - player width)
   41BF 28 04         [12]  158 	jr z, dont_move_r						;; Dont move the player
                            159 
   41C1 3C            [ 4]  160 		inc a 							;; Else: A++
   41C2 32 5B 41      [13]  161 		ld (player_x), a 				;; Player_x Update
                            162 
   41C5                     163 	dont_move_r:
   41C5 C9            [10]  164 ret
                            165 
                            166 
                            167 
                            168 ;;====================================
                            169 ;; Move Player Left
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                            170 ;; DESTROY: AF
                            171 ;;====================================
   41C6                     172 movePlayerLeft:
                            173 
   41C6 3A 5B 41      [13]  174 	ld a, (player_x)					;; A == Player_x
   41C9 FE 00         [ 7]  175 	cp #0								;; Check if player (screen rigth limit)
   41CB 28 04         [12]  176 	jr z, dont_move_l
                            177 	 
   41CD 3D            [ 4]  178 		dec a 							;; Else: A-- (Player_X--)
   41CE 32 5B 41      [13]  179 		ld (player_x), a 				;; Player_x Update 
                            180 
   41D1                     181 	dont_move_l:
   41D1 C9            [10]  182 ret
                            183 
                            184 ;;====================================
                            185 ;; Handle Events
                            186 ;; DESTROY: AF, BC, DE, HL
                            187 ;;====================================
   41D2                     188 HandleEvent:
   41D2 CD DB 41      [17]  189 	call check_KeyD_pressed
   41D5 CD EC 41      [17]  190 	call check_KeyA_pressed
   41D8 CD FD 41      [17]  191 	call check_KeyW_pressed
                            192 	
   41DB                     193 		check_KeyD_pressed:
   41DB CD 14 43      [17]  194 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   41DE 21 07 20      [10]  195 			ld hl, #Key_D 						;; HL = KEY 'D' Code
   41E1 CD 27 42      [17]  196 			call cpct_isKeyPressed_asm			;; Check for key 'D' is presed
   41E4 FE 00         [ 7]  197 			cp #0 								;; Check A == 0
   41E6 28 03         [12]  198 			jr z, d_not_pressed					;; Jump if A == 0 ('D' not pressed)
                            199 				
   41E8 CD BA 41      [17]  200 				call movePlayerRight			;; 'D' is pressed
                            201 		
   41EB                     202 			d_not_pressed:						;; Do nothing
                            203 		
   41EB C9            [10]  204 		ret
                            205 
   41EC                     206 		check_KeyA_pressed:
   41EC CD 14 43      [17]  207 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   41EF 21 08 20      [10]  208 			ld hl, #Key_A 						;; HL = KEY 'A' Code
   41F2 CD 27 42      [17]  209 			call cpct_isKeyPressed_asm			;; Check for key 'A' is presed
   41F5 FE 00         [ 7]  210 			cp #0 								;; Check A == 0
   41F7 28 03         [12]  211 			jr z, a_not_pressed					;; Jump if A == 0 ('A' not pressed)
                            212 		
   41F9 CD C6 41      [17]  213 				call movePlayerLeft				;; 'A' is pressed
                            214 		
   41FC                     215 			a_not_pressed:						;; Do nothing
                            216 
   41FC C9            [10]  217 		ret
                            218 
   41FD                     219 		check_KeyW_pressed:
   41FD CD 14 43      [17]  220 			call cpct_scanKeyboard_asm			;; Scan all keyboard
   4200 21 07 08      [10]  221 			ld hl, #Key_W 						;; HL = KEY 'W' Code
   4203 CD 27 42      [17]  222 			call cpct_isKeyPressed_asm			;; Check for key 'W' is presed
   4206 FE 00         [ 7]  223 			cp #0 								;; Check A == 0
   4208 28 03         [12]  224 			jr z, w_not_pressed					;; Jump if A == 0 ('W' not pressed)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            225 		
   420A CD AE 41      [17]  226 				call startJump					;; 'W' is pressed
                            227 		
   420D                     228 			w_not_pressed:						;; Do nothing
                            229 
   420D C9            [10]  230 		ret
                            231 
                            232 
   420E C9            [10]  233 ret
                            234 ;;====================================
                            235 ;; Draw Player
                            236 ;; INPUTS:
                            237 ;; 		A ==> Color Patern
                            238 ;; DESTROY: AF, BC, DE, HL
                            239 ;;====================================
   420F                     240 drawPlayer:
                            241 	
   420F F5            [11]  242 	push af 							;; Save A in Stack
                            243 	;;Calculate scrren position
   4210 11 00 C0      [10]  244 	ld 		de, #0xC000					;;Video Memory Pointer
   4213 3A 5B 41      [13]  245 	ld 		 a, (player_x)				;;|
   4216 4F            [ 4]  246 	ld 		 c, a 						;; C = Player_x
   4217 3A 5C 41      [13]  247 	ld 		 a, (player_y)				;;|
   421A 47            [ 4]  248 	ld 		 b, a 						;; B = Player_y
   421B CD F8 42      [17]  249 	call 	cpct_getScreenPtr_asm		;; Get Pointer to Screen (return to HL)
                            250 	
                            251 
                            252 	;; Draw a box
   421E EB            [ 4]  253 	ex 		de, hl 						;; intercabia ambos valores DE --> to Screen Pointer 
   421F F1            [10]  254 	pop 	af							;; A = User Selecter Color
   4220 01 02 08      [10]  255 	ld 		bc, 	#0x0802				;; 8x8 pixeles
   4223 CD 4B 42      [17]  256 	call 	 cpct_drawSolidBox_asm		;; Llamar dibujar solidBox
                            257 
   4226 C9            [10]  258 ret
                            259 
                            260 
                            261 
                            262 
                            263 
                            264 
                            265 
