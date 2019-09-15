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
                             11 .globl  player_getPtrHL
                             12 
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
                              8 .globl 	enemy_getX ;;deprecated
                              9 .globl 	enemy_checkCollision
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
   4000 CD 12 42      [17]   17 	call cpct_disableFirmware_asm
                             18 ;;=======================
                             19 ;; FLOOR
                             20 ;;=======================
   4003 CD F2 40      [17]   21    	call draw_floor 					;; Draw Floor
                             22 
                             23 
                             24 ;;=======================
                             25 ;; PLAYER
                             26 ;;=======================
   4006 CD F6 40      [17]   27 	call player_erase 					;; Erase player
   4009 CD 64 40      [17]   28 	call enemy_erase					;; Erase enemy
                             29 
   400C CD FC 40      [17]   30 	call player_update					;; Player Update
   400F CD 6A 40      [17]   31 	call enemy_update					;; Enemy update
                             32 
   4012 CD 09 41      [17]   33 	call player_getPtrHL
   4015 CD 34 40      [17]   34 	call enemy_checkCollision
   4018 32 00 C0      [13]   35 	ld (0xC000), a 						;; Draw collision led
   401B 32 01 C0      [13]   36 	ld (0xC001), a 						;; Draw collision led
   401E 32 02 C0      [13]   37 	ld (0xC002), a 						;; Draw collision led
   4021 32 03 C0      [13]   38 	ld (0xC003), a 						;; Draw collision led
                             39 
                             40 
   4024 CD 03 41      [17]   41 	call player_draw					;; Draw the Player
   4027 CD 6E 40      [17]   42 	call enemy_draw						;; Enemy draw
                             43 
                             44 	;call enemy_getX 					;; B = Enemy_X 		deprecated
                             45 	;call player_collition				;; Compare Player_X == Enemy_X --> RED	deprecated
                             46 
                             47 ;;=======================
                             48 ;; ENEMY
                             49 ;;=======================
                             50  	
                             51 
                             52 ;;=======================
                             53 ;; V-SYNC
                             54 ;;=======================
   402A CD 0A 42      [17]   55 	call cpct_waitVSYNC_asm 			;;Wait for Raster outside
                             56 
                             57 
   402D 18 D1         [12]   58 	jr _main
                             59 
                             60 
                             61 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                             62 
                             63 
