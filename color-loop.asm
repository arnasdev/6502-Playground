; Fill the screen with pink pixels

; BNE = Branch if not equals, jump if zero flag is clear
; BEQ = Branch if equals, jump if zero flag is set
; CMP = Compare the contents of the accumulator with an address, set zero and carry flags
; BCC = Branch if the carry flag is clear

define COLOR_LOCATION   = $0003

LDA #$01
STA COLOR_LOCATON

; Initialize our address pointer to $0200. Little endian means low byte goes first
reset_screen_pointer:
 LDA #$00
 STA $0000      ; Low byte of address
 LDA #$02
 STA $0001      ; High byte of address
 LDY #$00	; Y counter used to get the index/offset

loop:		;										PC=$060a
  LDA COLOR_LOCATION
  STA ($00),Y   ; Store color to address [$00,$01] + Y. 					PC=$060e
  INY           ; Increment Y									PC=$060f
  BNE continue  ; When Y has wrapped to 0, we continue below, else we branch to continue	PC=$061a

  INC $01       ; If Y has wrapped, increment the high byte of our address pointer
  LDA $01	; Load the high byte to A for the below comparison
  CMP #$06      ; If the high byte has hit #$06, we've passed the address $0600. 
  BCC continue  ; If not, continue
  
  CLC			; Clear the carry flag
  LDA COLOR_LOCATION 	; Load the current color
  CMP #$10		; Set carry flag if we've looped through all the colors. 10 in hex = 16
  BCC next_color

  BRK           ; Otherwise, we've filled all the pixels. 	PC=$062c

continue:
  JMP loop      ; Jump back to the start of the loop				PC=$061a

next_color:
  INC COLOR_LOCATION
  JMP reset_screen_pointer