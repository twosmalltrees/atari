; dasm cleanmem.asm -f3 -v0 -ocart.bin
;
  processor 6502

  seg code
  org $F000   ; Define the code origin at $F000

Start:
  sei             ; Disable interrupts
  cld             ; Disable the BCD (Binary Coded Decimal?) math mode
  ldx #$FF        ; Loads the X register with literal hexadecimal FF
  txs             ; Transfer the X register to the (S)tack pointer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the Page Zero region ($00 to $FF)
; Meaning the entire RAM and also clear the entire TIA register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  lda #0          ; A=0
  ldx #$FF        ; X=#$FF
  sta $FF

MemLoop:
  dex             ; X--
  sta $0,X        ; Store the value of A inside memory address $0 + X
  bne MemLoop     ; Loop until X is equal to zero (Z flag is set)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  org $FFFC       ; Need to fill the last 4 bytes, final ROM address is $FFFF, so go to $FFFC
  .word Start     ; Reset vector at $FFFC (where the program starts) => 2 bytes
  .word Start     ; Interrupt vector at $FFFE (unused in the vcs) => 2 bytes
