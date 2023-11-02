;************************************************************************
;
;		geosMacros
;
;	This file contains some macro definitions which can be used by
;	GEOS applications.
;
;Copyright (c) 1987 Berkeley Softworks. For the sole use of registered
;GeoProgrammer owners.
;************************************************************************

;************************************************************************
;
;	Load Byte:    LoadB  dest,value
;
;	Args:	dest - address of byte to load with value
;		value - byte to load
;
;	Action:	Load a byte with a value
;
;*************************************************************************
LoadB   .macro  dest,value
	lda	#\value	    ;load value
	sta	\dest		;store it
.endm

;************************************************************************
;
;	Load Word:    LoadW  dest,value
;
;	Args:	dest - address of word to load with value
;		value - word to load
;
;	Action:	Load a word with a value
;
;*************************************************************************
LoadW   .macro  dest,value
	lda	#>(\value)	;get higher byte of value to load
	sta	\dest+1	    ;store it
	lda	#<(\value)	;get lower byte of value to load
	sta	\dest+0	    ;store it
.endm

;************************************************************************
;
;	Move Byte:    MoveB  source,dest
;
;	Args:	source - source address
;		dest - destination address
;
;	Action:	Moves byte contents of source to destination.
;
;*************************************************************************
MoveB   .macro		source,dest
	lda	\source	    ;load data from source
	sta	\dest		;store it in destination
.endm

;************************************************************************
;
;	Move Word:    MoveW  source,dest
;
;	Args:	source - source address
;		dest - destination address
;
;	Action:	Moves a word from source address to dest address.
;
;*************************************************************************
MoveW   .macro		source,dest
	lda	\source+1	;get high byte
	sta	\dest+1	    ;store it
	lda	\source+0	;get low byte
	sta	\dest+0	    ;store it
.endm

;************************************************************************
;
;	Add Byte:    add  source
;
;	Args:	source - address of byte to add, or immediate value
;
;	Action:	a = a + source
;
;*************************************************************************
add .macro	source
	clc
	adc	\source
.endm
;************************************************************************
;
;	Add Bytes:    AddB  source,dest
;
;	Args:	source - address of byte to add
;		dest - address of byte to add to
;
;	Action:	dest = dest + source
;
;*************************************************************************
AddB    .macro		source,dest
	clc		        ;must add with carry
	lda	\source	    ;get source byte
	adc	\dest		;add to destination byte
	sta	\dest	    ;store result
.endm

;************************************************************************
;
;	Add Words:    AddW  source,dest
;
;	Args:	source - address of word to add
;		dest - address of word to add to
;
;	Action:	dest = dest + source
;	
;*************************************************************************
AddW    .macro		source,dest
	lda	\source	    ;get source low byte
	clc
	adc	\dest+0	    ;add to destination low byte
	sta	\dest+0		;store result, sec carry with overflow
	lda	\source+1	;get source high byte
	adc	\dest+1	    ;add with carry to high byte dest
	sta	\dest+1		;store result
.endm

;************************************************************************
;
;	Add Value To Byte:    AddVB  value,dest
;
;	Args:	value - constant to add to dest
;		dest - address of byte to add to
;
;	Action:	dest = dest + value
;
;*************************************************************************
AddVB   .macro		value,dest
	lda	\dest
	clc
	adc	#\value
	sta	\dest
.endm

;************************************************************************
;
;	Add Value to Word:    AddVW  value,dest
;
;	Args:	value - constant to add to dest
;		dest - address of word to add to
;
;	Action:	dest = dest + value
;
;*************************************************************************
AddVW   .macro		value,dest
	clc		            ;must add with carry
	lda	#<(\value)	    ;get low byte of value
	adc	\dest+0	        ;add to low byte of word
	sta	\dest+0		    ;store updated value

.if	(\value >= 0) && (\value <= 255)
	bcc	noInc	        ;carry was set if adc above overflowed.
	inc	\dest+1		    ;increment high byte of word
noInc:
.else
	lda	#>(\value)	    ;carry was set if adc above overflowed.
	adc	\dest+1	        ;add carry + 0 to high byte of address
	sta	\dest+1		    ;store result
.endif

.endm

;************************************************************************
;
;	Subtract Byte:    sub  source
;
;	Args:	source - address of byte to subtract, or immediate value
;
;	Action:	a = a - source
;
;*************************************************************************
sub .macro		source
	sec
	sbc	\source
.endm

;************************************************************************
;
;	Sub Bytes:    SubB  source,dest
;
;	Args:	source - address of byte to subtract
;		dest - address of byte to subtract from
;
;	Action:	dest = dest - source
;
;*************************************************************************
SubB    .macro		source,dest
	sec		        ;must add with carry
	lda	\dest	    ;get destination byte
	sbc	\source		;subtract source byte
	sta	\dest	    ;store result
.endm

;************************************************************************
;
;	Sub Words:    SubW  source,dest
;
;	Args:	source - address of byte to subtract
;		dest - address of byte to subtract from
;
;	Action:	dest = dest - source
;
;*************************************************************************
SubW    .macro		source,dest
	lda	\dest+0	    ;get source low byte
	sec
	sbc	\source+0	;subtract from destination low byte
	sta	\dest+0	    ;store result, clc carry with overflow
	lda	\dest+1		;get source high byte
	sbc	\source+1	;sub with carry from destination high byte
	sta	\dest+1	    ;store result
.endm

;************************************************************************
;
;	Compare Bytes:    CmpB  source,dest
;
;	Args:	source - address of first byte
;		dest - address of second byte
;
;	Action:	compare contents of source byte to contents of dest. byte
;
;************************************************************************
CmpB    .macro		source,dest
	lda	\source	    ;get source byte
	cmp \dest		;compare source to dest	
.endm

;************************************************************************
;
;	Compare Byte To Value:    CmpBI  source,immed
;
;	Args:	source - address of first byte
;	 	immed - value to compare to
;
;	Action:	compares contents of source to value
;
;************************************************************************
CmpBI   .macro		source,immed
	lda	\source	    ;get source byte
	cmp #\immed		;compare source to immediate value
.endm

;************************************************************************
;
;	Compare Words:    CmpW  source,dest
;
;	Args:	source - address of first word
;		dest - address of second word
;
;	Action:	compare contents of source word to contents of dest. word
;
;************************************************************************
CmpW    .macro		source,dest
	lda	\source+1	;get high source byte
	cmp	\dest+1	    ;compare source to dest	
	bne	done		;need to do low byte?
	lda	\source+0	;do low byte
	cmp	\dest+0	    ;compare low byte
done:
.endm

;************************************************************************
;
;	Compare Word To Value:    CmpWI  source,immed
;
;	Args:	source - address of first word
;		immed - value to compare to
;
;	Action:	compares contents of source to value
;
;************************************************************************
CmpWI   .macro		source,immed
	lda	\source+1	;get high byte
	cmp	#>(\immed)	;test high byte of immediate value
	bne	done	;   don't need to do low byte
	lda	\source+0	;test low byte
	cmp	#<(\immed)
done:
.endm
;************************************************************************
;
;	Push Byte:    PushB  source
;
;	Args:	source - address of the byte to push
;
;	Action:	Pushes the byte at source onto the stack
;
;*************************************************************************
PushB   .macro		source
	lda	\source	    ;get byte
	pha			    ;and push it
.endm

;************************************************************************
;
;	Push Word:    PushW  source
;
;	Args:	source - address of the word to push
;
;	Action:	Pushes the word at source onto the stack
;
;*************************************************************************
PushW   .macro		source
	lda	\source+1	;get high byte of word
	pha		        ;and push it
	lda	\source+0	;get low byte of word
	pha		        ;and push it
.endm

;************************************************************************
;
;	Pop Byte:    PopB  dest
;
;	Args:	dest - where to store byte value
;
;	Action:	Pops a byte from the stack
;
;*************************************************************************
PopB    .macro		dest
	pla		        ;get byte
	sta	\dest	    ;and save it
.endm

;************************************************************************
;
;	Pop Word:    PopW  dest
;
;	Args:	dest - where to store word value
;
;	Action:	Pops a word from the stack
;
;*************************************************************************
PopW    .macro		dest
	pla		        ;get low byte of word
	sta	\dest+0	    ;and save it
	pla			    ;get high byte of word
	sta	\dest+1	    ;and save it
.endm

;*************************************************************************
;
;	Branch Relative Always:    bra  addr
;
;	Args:	addr - where to branch to
;
;	Action:	unconditional relative branch
;
;************************************************************************
bra     .macro		addr
	clv
	bvc	\addr
.endm

;************************************************************************
;
;	Set Bit:    smb  bitNumber,dest
;
;	Args:	bitNumber - bit number in byte to set (7 for MSD, 0 for LSD)
;		dest - address of byte which contains bit to set
;
;	Action:	sets bit in destination byte
;		fast version (smbf) trashes the accumulator
;
;************************************************************************
smb     .macro		bitNumber,dest
	pha
	lda	#(1 << \bitNumber)
	ora	\dest
	sta	\dest
	pla
.endm

smbf    .macro		bitNumber,dest
	lda	#(1 << \bitNumber)
	ora	\dest
	sta	\dest
.endm
;************************************************************************
;
;	Reset Bit:    rmb  bitNumber,dest
;
;	Args:	bitNumber - bit number in byte to reset (7 for MSD, 0 for LSD)
;		dest - address of byte which contains bit to reset
;
;	Action:	resets bit in destination byte
;		fast version (rmbf) trashes the accumulator
;
;************************************************************************
rmb     .macro		bitNumber,dest
	pha
	lda	#<~(1 << \bitNumber)
	and	\dest
	sta	\dest
	pla
.endm

rmbf    .macro		bitNumber,dest
	lda	#<~(1 << \bitNumber)
	and	\dest
	sta	\dest
.endm

;************************************************************************
;
;	Branch on Bit Set:    bbs  bitNumber,source,addr
;
;	Args:	bitNumber - bit number in byte to test (7 for MSD, 0 for LSD)
;		source - address of byte which contains bit to test
;		addr - where to branch to if bit is set
;
;	Action:	tests bit in source byte, branches if is set
;		fast version (bbsf) trashes the accumulator
;
;************************************************************************
bbs     .macro		bitNumber,source,addr
	php
	pha
	lda	\source
	and	#(1 << \bitNumber)
	beq	nobranch
	pla
	plp
	bra	\addr
nobranch:
	pla
	plp
.endm

bbsf    .macro		bitNumber,source,addr
.if	(\bitNumber = 7)
	bit	\source
	bmi	\addr
.elif	(\bitNumber = 6)
	bit	\source
	bvs	\addr
.else
	lda	\source
	and	#(1 << \bitNumber)
	bne	\addr
.endif
.endm

;************************************************************************
;
;	Branch on Bit Reset:    bbr  bitNumber,source,addr
;
;	Args:	bitNumber - bit number in byte to test (7 for MSD, 0 for LSD)
;		source - address of byte which contains bit to test
;		addr - where to branch to if bit is reset
;
;	Action:	tests bit in source byte, branches if is reset
;		fast version (bbsf) trashes the accumulator
;
;************************************************************************
bbr     .macro		bitNumber,source,addr
	php
	pha
	lda	\source
	and	#(1 << \bitNumber)
	bne	nobranch
	pla
	plp
	bra	\addr
nobranch:
	pla
	plp
.endm

bbrf    .macro		bitNumber,source,addr
.if	(\bitNumber = 7)
	bit	\source
	bpl	\addr
.elif	(\bitNumber = 6)
	bit	\source
	bvc	\addr
.else
	lda	\source
	and	#(1 << \bitNumber)
	beq	\addr
.endif
.endm
