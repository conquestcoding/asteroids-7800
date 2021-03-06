*         0042    221283
*
*
** ROCKMOVE.S **
** ASTEROIDS FOR THE ATARI 3600 **
** THIS FILE CONTAINS THE ROCK MOVEMENT ROUTINE. **


ROCKMOVE:
	LDX     #32

MOVELOOP:
	LDA     STATUS,X
;	CMP     #$FF		;UNCOMMENT FOR MOVING EXPLOSIONS
;	BNE     THISMOVE	;UNCOMMENT FOR MOVING EXPLOSIONS
	BPL     THISMOVE	;COMMENT FOR MOVING EXPLOSIONS

NEXTMOVE:
	DEX
	BPL     MOVELOOP
	RTS

THISMOVE:
	AND     #$0F
	TAY

	CLC			;GET NEW XPOS
	LDA     XVELL,X
	ADC     XPOSL,X
	STA     XPOSL,X
	LDA     XVELH,X
	ADC     XPOSH,X
	CMP     #XPOSMAX	;CHECK FOR WRAPAROUND
	BCC     SETXPOS
;	CMP     #XPOSMIN
;	BCS     SETXPOS
	CPX     #25		;DON'T WRAP THE UFO
	BEQ     SETXPOS
	LDA     XVELH,X
	BMI     NEGOVELX
	LDA     #XPOSMIN
	JMP     SETXPOS
NEGOVELX:
	LDA     #XPOSMAX
SETXPOS:
	STA     XPOSH,X
	CLC
	ADC     DELTAX,Y
	STA     COLXPOSH,X

	CLC			;GET NEW YPOS
	LDA     YVELL,X
	ADC     YPOSL,X
	STA     YPOSL,X
	LDA     YVELH,X
	ADC     YPOSH,X
	CMP     #YPOSMAX	;CHECK FOR WRAPAROUND
	BCC     SETYPOS
;	CMP     #YPOSMIN
;	BCS     SETYPOS
	LDA     YVELH,X
	BMI     NEGOVELY
	LDA     #YPOSMIN
	JMP     SETYPOS
NEGOVELY:
	LDA     #YPOSMAX
SETYPOS:
	STA     YPOSH,X
	CLC
	ADC     DELTAY,Y
	STA     COLYPOSH,X

	CPY     #3
	BCS     NEXTMOVE
	LDA     STATUS,X
	BMI     NEXTMOVE

	TXA			;GET NEW ANIMATION INDEX
	ASL
	ADC     FRMCNT
	LSR
	AND     AVEL,X		;AVEL ANDED WITH FRMCNT TO DECIDE
	BNE     NEXTMOVE	;WHEN NEXT ANIMATION

	LDA     ASPIN,X
	BMI     NEGOSPIN

POSOSPIN:
	CPY     #1
	BCC     PSANIM
	BEQ     PMANIM

PLANIM:
	TAY
	LDA     ACYC,X
	ADC     #2		;CARRY IS SET
	CMP     LBOUND+1,Y
	BMI     SETACYC
	LDA     LBOUND,Y
	JMP     SETACYC

PMANIM:
	TAY
	LDA     ACYC,X
	ADC     #1		;CARRY IS SET
	CMP     MBOUND+1,Y
	BMI     SETACYC
	LDA     MBOUND,Y
	JMP     SETACYC

PSANIM:
	TAY
	LDA     ACYC,X
	ADC     #1		;CARRY IS CLEAR
	CMP     SBOUND+1,Y
	BMI     SETACYC
	LDA     SBOUND,Y
	JMP     SETACYC

NEGOSPIN:
	AND     #$7F
	CPY     #1
	BCC     NSANIM
	BEQ     NMANIM

NLANIM:
	TAY
	LDA     ACYC,X
	SBC     #3		;CARRY IS SET
	CMP     LBOUND,Y
	BPL     SETACYC
	LDA     LBOUND+1,Y
	SEC
	SBC     #3
	JMP     SETACYC

NMANIM:
	TAY
	LDA     ACYC,X
	SBC     #2		;CARRY IS SET
	CMP     MBOUND,Y
	BPL     SETACYC
	LDA     MBOUND+1,Y
	SEC
	SBC     #2
	JMP     SETACYC

NSANIM:
	TAY
	LDA     ACYC,X
	SBC     #0		;CARRY IS CLEAR
	CMP     SBOUND,Y
	BPL     SETACYC
	LDA     SBOUND+1,Y
	SEC
	SBC     #1

SETACYC:
	STA     ACYC,X
	JMP     NEXTMOVE

SHOTMOVE:
	LDX     #5
LOOPSHOT:
	LDA     STATUS+26,X
	BMI     SHOTNEXT
	INC     SHOTCNT,X
	BNE     SHOTNEXT
	LDA     #$FF
	STA     STATUS+26,X
SHOTNEXT:
	DEX
	BPL     LOOPSHOT
	RTS


ASPIN:
    	.DC.B	$00,$80,$01,$81,$02,$82,$00,$80,$01,$81,$02,$82
	.DC.B	$00,$80,$01,$81,$02,$82,$00,$80,$01,$81,$02,$82

AVEL:
	.DC.B	1,3,0,1,3,0,1,3,0,1,3,0
	.DC.B	3,0,1,3,0,1,3,0,1,3,0,1

LBOUND:
   	.DC.B	ROCK1L1 & 255,ROCK2L1 & 255,ROCK3L1 & 255,ROCKEL1 & 255
MBOUND:
   	.DC.B	ROCK1M1 & 255,ROCK2M1 & 255,ROCK3M1 & 255,ROCKEM1 & 255
SBOUND:
   	.DC.B	ROCK1S1 & 255,ROCK2S1 & 255,ROCK3S1 & 255,ROCKES1 & 255

ELBOUND:
  	.DC.B	ROCKES1 & 255,ROCKEM1 & 255,ROCKEL1 & 255,SHIPE1 & 255
	.DC.B	ROCKES1 & 255,ROCKEM1 & 255,SHOT1 & 255,SHIPE1 & 255
EHBOUND:
  	.DC.B	ROCKES5 & 255,ROCKEM5 & 255,ROCKEL5 & 255,SHIPE6 & 255
	.DC.B	ROCKES5 & 255,ROCKEM5 & 255,SHOT1 & 255,SHIPE6 & 255

ROCKCYC:
  	.DC.B	ROCK1S1 & 255,ROCK1M1 & 255,ROCK1L1 & 255

DELTAX:
   	.DC.B	     2,3,5,3,2,3,0	;XCENTER
DELTAY:
   	.DC.B	     13,10,8,9,13,12,0	;YCENTER

