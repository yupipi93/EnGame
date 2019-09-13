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
                              5 .globl 	draw_floor
                              6 
                              7 .globl	player_erase
                              8 .globl	player_update
                              9 .globl	player_draw
                             10 .globl 	player_collition
                             11 
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
                              8 .globl 	enemy_getX
                              9 .globl 	enemy_getX
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              6 .include 	"cpctelera.h.s"
                              1 ;; CPCtelera Symbols
                              2 .globl cpct_drawSolidBox_asm
                              3 .globl cpct_getScreenPtr_asm
                              4 
                              5 .globl cpct_scanKeyboard_asm
                              6 .globl cpct_isKeyPressed_asm
                              7 
                              8 .globl cpct_waitVSYNC_asm
                              9 .globl cpct_disableFirmware_asm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              7 
                              8 
                              9 
                             10 
                             11 ;;====================================
                             12 ;; Main program
                             13 ;;====================================
                             14 
                             15 
   4000                      16 _main::
   4000 CD CB 41      [17]   17 	call cpct_disableFirmware_asm
                             18 ;;=======================
                             19 ;; FLOOR
                             20 ;;=======================
   4003 CD B2 40      [17]   21    	call draw_floor 					;; Draw Floor
                             22 
                             23 
                             24 ;;=======================
                             25 ;; PLAYER
                             26 ;;=======================
   4006 CD B6 40      [17]   27 	call player_erase 					;; Erase player
   4009 CD 26 40      [17]   28 	call enemy_erase					;; Erase enemy
                             29 
   400C CD BC 40      [17]   30 	call player_update					;; Player Update
   400F CD 2C 40      [17]   31 	call enemy_update					;; Enemy update
                             32 
   4012 CD C3 40      [17]   33 	call player_draw					;; Draw the Player
   4015 CD 30 40      [17]   34 	call enemy_draw						;; Enemy draw
                             35 
   4018 CD 36 40      [17]   36 	call enemy_getX 					;; B = Enemy_X 
   401B CD C9 40      [17]   37 	call player_collition				;; Compare Player_X == Enemy_X --> RED	
                             38 
                             39 ;;=======================
                             40 ;; ENEMY
                             41 ;;=======================
                             42  	
                             43 
                             44 ;;=======================
                             45 ;; V-SYNC
                             46 ;;=======================
   401E CD C3 41      [17]   47 	call cpct_waitVSYNC_asm 			;;Wait for Raster outside
                             48 
                             49 
   4021 18 DD         [12]   50 	jr _main
                             51 
                             52 
                             53 
                             54 
                             55 
