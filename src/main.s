.area _DATA
.area _CODE 

.include 	"player.h.s"
.include 	"enemy.h.s"
.include 	"collision.h"
.include 	"cpctelera.h.s"



;;====================================
;; Initialize program
;;====================================
initialize_program:
	call cpct_disableFirmware_asm
ret 
;;====================================
;; Main program
;;====================================


_main::

	call initialize_program
	

;;=======================
;; PLAYER
;;=======================
	call player_erase 					;; Erase player
	call enemy_erase					;; Erase enemy

	call player_update					;; Player Update
	call enemy_update					;; Enemy update

	call player_getPtrHL
	call enemy_getPtrDE
	;call enemy_checkCollision
	call checkCollision
	ld (0xC000), a 						;; Draw collision led
	ld (0xC001), a 						;; Draw collision led
	ld (0xC002), a 						;; Draw collision led
	ld (0xC003), a 						;; Draw collision led


	call player_draw					;; Draw the Player
	call enemy_draw						;; Enemy draw

	



;;=======================
;; V-SYNC
;;=======================
	call cpct_waitVSYNC_asm 			;;Wait for Raster outside


	jr _main





