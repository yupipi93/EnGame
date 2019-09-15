.area _DATA
.area _CODE 

.include 	"player.h.s"
.include 	"enemy.h.s"
.include 	"cpctelera.h.s"




;;====================================
;; Main program
;;====================================


_main::
	call cpct_disableFirmware_asm
;;=======================
;; FLOOR
;;=======================
   	call draw_floor 					;; Draw Floor


;;=======================
;; PLAYER
;;=======================
	call player_erase 					;; Erase player
	call enemy_erase					;; Erase enemy

	call player_update					;; Player Update
	call enemy_update					;; Enemy update

	call player_getPtrHL
	call enemy_checkCollision
	ld (0xC000), a 						;; Draw collision led
	ld (0xC001), a 						;; Draw collision led
	ld (0xC002), a 						;; Draw collision led
	ld (0xC003), a 						;; Draw collision led


	call player_draw					;; Draw the Player
	call enemy_draw						;; Enemy draw

	;call enemy_getX 					;; B = Enemy_X 		deprecated
	;call player_collition				;; Compare Player_X == Enemy_X --> RED	deprecated

;;=======================
;; ENEMY
;;=======================
 	

;;=======================
;; V-SYNC
;;=======================
	call cpct_waitVSYNC_asm 			;;Wait for Raster outside


	jr _main





