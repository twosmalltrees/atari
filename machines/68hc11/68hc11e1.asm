
	.PROCESSOR 68HC11

FLASH_START		.EQU	$B600
FLASH_SIZE 		.EQU	512
BOOTROM_START		.EQU	$BF00
DOWNLOAD_SIZE		.EQU	512


	#include	"register.asm"