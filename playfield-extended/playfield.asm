  processor 6502

  include "vcs.h"
  include "macro.h"

  seg code
  org $F000

Reset:
  CLEAN_START                   ; Macro to safely clear memory and TIA

  ldx #$80
  stx COLUBK                    ; Set background color to blue-ish

  ldx #$1C
  stx COLUPF                    ; Set play-field color to yellow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start a new frame by turning on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame:
  lda #2                        ; Same as binary value %00000010
  sta VBLANK                    ; Turn on VBLANK
  sta VSYNC                     ; Turn on VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  REPEAT 3
    sta WSYNC                   ; Three scanlines for VSYNC
  REPEND

  lda #0
  sta VSYNC                     ; Turn off VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Let the TIA output the recommended 37 lines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  REPEAT 37
    sta WSYNC                   ; Three scanlines for VSYNC
  REPEND

  lda #0
  sta VBLANK                    ; Turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set CTRLPF register to allow playfield reflection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ldx #%00000001
  stx CTRLPF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 192 visible scanlines (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; First 7 scanlines, no playfield
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ldx #0
  stx PF0
  stx PF1
  stx PF2
  REPEAT 7
    sta WSYNC
  REPEND

  ldx #%11100000
  stx PF0
  ldx #%11111111
  stx PF1
  stx PF2
  REPEAT 7
    sta WSYNC
  REPEND

  ldx #%01100000
  stx PF0
  ldx #0
  stx PF1
  ldx #%10000000
  stx PF2
  REPEAT 164
    sta WSYNC
  REPEND

  ldx #%11100000
  stx PF0
  ldx #%11111111
  stx PF1
  stx PF2
  REPEAT 7
    sta WSYNC
  REPEND

  ldx #0
  stx PF0
  stx PF1
  stx PF2
  REPEAT 7
    sta WSYNC
  REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 30 more VBLANK lines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  lda #2
  sta VBLANK
  REPEAT 30
    sta WSYNC
  REPEND
  lda #0
  sta VBLANK

  jmp NextFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM Size to 4kb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  org $FFFC
  .word Reset
  .word Reset
