;;;
;;;
;;;


INIT:
	;; Reset USART
;	LD	A,00H
;	OUT	(USARTC),A
;	LD	A,00H
;	OUT	(USARTC),A
;	LD	A,00H
;	OUT	(USARTC),A
;	LD	A,40H
;	OUT	(USARTC),A

	;;
;	LD	A,4EH
;	OUT	(USARTC),A

	;;
;	LD	A,37H
;	OUT	(USARTC),A

	RET

CONIN:
	LD	A,(USARTC)
;	AND	02H
	BIT	0,A
	JR	Z,CONIN
	LD	A,(USARTD)

	RET

CONST:
	LD	A,(USARTC)
;	AND	02H
	BIT	0,A

	RET

CONOUT:
	PUSH	AF
COUT0:	LD	A,(USARTC)
;	AND	01H
	BIT	1,A
	JR	Z,COUT0
	POP	AF
	LD	(USARTD),A

	RET

