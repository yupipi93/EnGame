ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .area _DATA
                              2 .area _CODE 
                              3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              4 .include 	"player.h.s"
                              1 ;; ########################################
                              2 ;; PLAYER PUBLIC FUNCTIONS
                              3 ;; ########################################
                              4 
                              5 .globl	player_erase
                              6 .globl	player_update
                              7 .globl	player_draw
                              8 .globl  player_getPtrHL
                              9 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              5 .include 	"enemy.h.s"
                              1 ;; ########################################
                              2 ;; ENEMY PUBLIC FUNCTIONS
                              3 ;; ########################################
                              4 
                              5 .globl	enemy_erase
                              6 .globl	enemy_update
                              7 .globl	enemy_draw
                              8 .globl 	enemy_checkCollision
                              9 .globl 	enemy_getPtrDE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              6 .include 	"collision.h"
                              1 ;; ########################################
                              2 ;; ENEMY PUBLIC FUNCTIONS
                              3 ;; ########################################
                              4 
                              5 .globl 	checkCollision
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              7 .include 	"cpctelera.h.s"
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



                              8 
                              9 
                             10 
                             11 ;;====================================
                             12 ;; Initialize program
                             13 ;;====================================
   4000                      14 initialize_program:
   4000 CD 3B 42      [17]   15 	call cpct_disableFirmware_asm
   4003 C9            [10]   16 ret 
                             17 ;;====================================
                             18 ;; Main program
                             19 ;;====================================
                             20 
                             21 
   4004                      22 _main::
                             23 
   4004 CD 00 40      [17]   24 	call initialize_program
                             25 	
                             26 
                             27 ;;=======================
                             28 ;; PLAYER
                             29 ;;=======================
   4007 CD 6F 41      [17]   30 	call player_erase 					;; Erase player
   400A CD E5 40      [17]   31 	call enemy_erase					;; Erase enemy
                             32 
   400D CD 75 41      [17]   33 	call player_update					;; Player Update
   4010 CD EB 40      [17]   34 	call enemy_update					;; Enemy update
                             35 
   4013 CD 82 41      [17]   36 	call player_getPtrHL
   4016 CD 8B 40      [17]   37 	call enemy_getPtrDE
                             38 	;call enemy_checkCollision
   4019 CD 33 40      [17]   39 	call checkCollision
   401C 32 00 C0      [13]   40 	ld (0xC000), a 						;; Draw collision led
   401F 32 01 C0      [13]   41 	ld (0xC001), a 						;; Draw collision led
   4022 32 02 C0      [13]   42 	ld (0xC002), a 						;; Draw collision led
   4025 32 03 C0      [13]   43 	ld (0xC003), a 						;; Draw collision led
                             44 
                             45 
   4028 CD 7C 41      [17]   46 	call player_draw					;; Draw the Player
   402B CD EF 40      [17]   47 	call enemy_draw						;; Enemy draw
                             48 
                             49 	
                             50 
                             51 
                             52 
                             53 ;;=======================
                             54 ;; V-SYNC
                             55 ;;=======================
   402E CD 33 42      [17]   56 	call cpct_waitVSYNC_asm 			;;Wait for Raster outside
                             57 
                             58 
   4031 18 D1         [12]   59 	jr _main
                             60 
                             61 
                             62 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                             63 
                             64 
