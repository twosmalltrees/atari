    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000                 ; Defines the origin of the ROM at $F000

    CLEAN_START               ; Macro to safely clear the memory

START:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set background luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  lda #$1E                    ; Load color into A register. $1E is NTSC Yellow
  sta COLUBK                  ; Store A to background color address $09 (see vcs.h)

  jmp START                   ; Repeat from the start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill ROM size to exactly 4kb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  org $FFFC                   ; Defines origin to $FFFC
  .word START
  .word START