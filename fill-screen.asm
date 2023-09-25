; Fill the screen with pink pixels

; BNE = Branch if not equals, jump if zero flag is clear
; BEQ = Branch if equals, jump if zero flag is set
; CMP = Compare the contents of the accumulator with an address, set zero and carry flags
; BCC = Branch if the carry flag is clear

define color $04 ; Pink Color

; Initialize our address pointer to $0200. Little endian means low byte goes first
LDA #$00
STA $00       ; Low byte of address
LDA #$02
STA $01       ; High byte of address

; Initialize Y to 0
LDY #$00      

loop:												PC=$060a
  LDA #color	;										PC=$060c
  STA ($00),Y   ; Store color to address [$00,$01] + Y. 					PC=$060e
  INY           ; Increment Y									PC=$060f
  BNE continue  ; When Y has wrapped to 0, we continue below, else we branch to continue	PC=$061a

  INC $01       ; If Y has wrapped, increment the high byte of our address pointer
  LDA $01	; Load the high byte to A for the below comparison
  CMP #$06      ; If the high byte has hit #$06, we've passed the address $0600. 
  BCC continue  ; If not, continue
  BRK           ; Otherwise, we've filled all the pixels.

continue:
  JMP loop      ; Jump back to the start of the loop						