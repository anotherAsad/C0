JMP #0
MOV R0, #0
MOV R3, #0

;; Sum of first n integers

L1:
ADD R3, R3, #1			; Loop Variable
ADD R0, R0, R3			; Sum variable
CMP R3, #10
JNE	L1

; Jump back to self for stopping the control flow.
STUCK: JMP STUCK
