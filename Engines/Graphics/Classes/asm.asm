	TTL	C:\Documents and Settings\administrator.HPT-OFFICE\Desktop\HPT Graphics\asm.asm

	EXPORT HPTMemCpyFastSARM
	EXPORT HPTMemCpyFastXSCALE
	EXPORT PageFlip
	EXPORT HPTPartialBlt
	EXPORT HPTPartialBltH
	EXPORT HPTPartialBltV
	EXPORT HPTPartialBltHV
	EXPORT HPTPartialBltO
	EXPORT HPTPartialBltHO
	EXPORT HPTPartialBltVO
	EXPORT HPTPartialBltHVO
	EXPORT HPTBlt16x16O
	EXPORT MemCpyFastLandscape

	AREA .code,CODE

HPTMemCpyFastSARM   PROC
	stmdb sp!,{r4-r11,r14}

	
	cmp r2,#0
	beq SKIPLOOP


BEGINLOOP2		
	mov r4,r1
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32
	ldrsb r5,[r4],#32

	mov r3,#16
BEGINLOOP
	ldmia r1!,{r4-r11}
	;stmia r0!,{r4-r11}
	subs r3,r3,#1

	;ldmia r1!,{r4-r11}
	stmia r0!,{r4-r11}

	bne BEGINLOOP
	subs r2,r2,#1
	bne BEGINLOOP2
SKIPLOOP


	ldmia sp!,{r4-r11,r15}
	endp


HPTMemCpyFastXSCALE   PROC
	stmdb sp!,{r4-r11,r14}

	pld [r1]
	pld [r1,#32]
	pld [r1,#64]
	;pld [r1,#96]
	cmp r2,#0
	beq SKIPLOOP4
BEGINLOOP4
	pld [r1,#96]
	;ldmia r1!,{r4-r11}
	;stmia r0!,{r4-r11}
	ldr r4,[r1] , #4
	ldr r5,[r1] , #4
	ldr r6,[r1] , #4
	ldr r7,[r1] , #4
	str r4,[r0] , #4
	str r5,[r0] , #4
	str r6,[r0] , #4
	str r7,[r0] , #4

	ldr r8,[r1] , #4
	ldr r9,[r1] , #4
	ldr r10,[r1] , #4
	ldr r11,[r1] , #4
	str r8,[r0] , #4
	str r9,[r0] , #4
	str r10,[r0] , #4
	str r11,[r0] , #4

	

	subs r2,r2,#1
	pld [r1,#96]
	;ldmia r1!,{r4-r11}
	;stmia r0!,{r4-r11}
	ldr r4,[r1] , #4
	ldr r5,[r1] , #4
	ldr r6,[r1] , #4
	ldr r7,[r1] , #4
	str r4,[r0] , #4
	str r5,[r0] , #4
	str r6,[r0] , #4
	str r7,[r0] , #4

	ldr r8,[r1] , #4
	ldr r9,[r1] , #4
	ldr r10,[r1] , #4
	ldr r11,[r1] , #4
	str r8,[r0] , #4
	str r9,[r0] , #4
	str r10,[r0] , #4
	str r11,[r0] , #4

	bne BEGINLOOP4
SKIPLOOP4


	ldmia sp!,{r4-r11,r15}


	endp

PageFlip   PROC
	stmdb sp!,{r4-r9,r14}

	pld [r1]
	pld [r1,#32]
	pld [r1,#64]
	;pld [r1,#96]
	mov r8,#320
BEGINLOOPPFY
	mov r9,#15
BEGINLOOPPFX
	pld [r1,#96]
	ldr r4,[r1] , #4
	ldr r5,[r1] , #4
	ldr r6,[r1] , #4
	ldr r7,[r1] , #4
	str r4,[r0] , #4
	str r5,[r0] , #4
	str r6,[r0] , #4
	str r7,[r0] , #4

	subs r9,r9,#1
	ldr r4,[r1] , #4
	ldr r5,[r1] , #4
	ldr r6,[r1] , #4
	ldr r7,[r1] , #4
	str r4,[r0] , #4
	str r5,[r0] , #4
	str r6,[r0] , #4
	str r7,[r0] , #4


	bne BEGINLOOPPFX

	subs r8,r8,#1
	add r1,r1,r2
	bne BEGINLOOPPFY

	ldmia sp!,{r4-r9,r15}


	endp


HPTPartialBlt   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 color
;r5 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance

	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4,r5}
	pld [r1]
	mov r2,r2, lsl #1
	mov r5,r5, lsl #1
	rsb r8,r2,#480
	mov r9,r5
	sub r5,r5,r2
BEGINY
	mov r6,r2
	pld [r1,r9]
BEGINX
		
		ldrh r7,[r1] , #2
		cmp r7,r4
		strneh r7,[r0]
	
		subs r6,r6,#2
		add r0,r0,#2
		bne BEGINX

	subs r3,r3,#1
	add r0,r0,r8
	add r1,r1,r5

	bne BEGINY


	ldmia sp!,{r4-r9,r15}

	endp

HPTPartialBltH   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 color
;r5 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance	
	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4,r5}
	pld [r1]
	;pld [r1,#32]
	mov r2,r2, lsl #1
	mov r5,r5, lsl #1
	rsb r8,r2,#480
	mov r9,r5
	sub r9,r9,r2
	add r5,r5,r2
BEGINYH
	mov r6,r2
	pld [r1,r9]

BEGINXH
		ldrh r7,[r1], #-2
		cmp r7,r4
		strneh r7,[r0]
		subs r6,r6,#2
		add r0,r0,#2
		;sub r1,r1,#2
		bne BEGINXH
	
	subs r3,r3,#1
	add r0,r0,r8
	add r1,r1,r5
	bne BEGINYH

	ldmia sp!,{r4-r9,r15}

	endp

HPTPartialBltV   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 color
;r5 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance
	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4,r5}
	pld [r1]
	mov r2,r2, lsl #1
	mov r5,r5, lsl #1
	rsb r8,r2,#480
	mov r9,r5
	add r5,r5,r2
BEGINYV
	mov r6,r2
	pld [r1,-r9]
BEGINXV
		ldrh r7,[r1] , #2
		cmp r7,r4
		strneh r7,[r0]
		subs r6,r6,#2
		add r0,r0,#2
		bne BEGINXV
	
	subs r3,r3,#1
	add r0,r0,r8
	sub r1,r1,r5
	bne BEGINYV

	ldmia sp!,{r4-r9,r15}

	endp

HPTPartialBltHV   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 color
;r5 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance

	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4,r5}
	pld [r1]
	mov r2,r2, lsl #1
	mov r5,r5, lsl #1
	rsb r8,r2,#480
	add r9,r5,r2
	sub r5,r5,r2
BEGINYHV
	mov r6,r2
	pld [r1,-r9]

BEGINXHV
		ldrh r7,[r1] , #-2
		cmp r7,r4
		strneh r7,[r0]
		subs r6,r6,#2
		add r0,r0,#2
		bne BEGINXHV
	
	subs r3,r3,#1
	add r0,r0,r8
	sub r1,r1,r5
	bne BEGINYHV

	ldmia sp!,{r4-r9,r15}

	endp

HPTPartialBltO   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance
	
	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4,r5}
	pld [r1]
	mov r2,r2, lsl #1
	mov r4,r4, lsl #1
	rsb r8,r2,#480
	mov r9,r4
	sub r4,r4,r2
BEGINYO
	mov r6,r2
	pld [r1,r9]
BEGINXO
		
		ldrh r7,[r1] , #2
		subs r6,r6,#2
		;cmp r7,r4
		strh r7,[r0]
	
		add r0,r0,#2
		bne BEGINXO

	subs r3,r3,#1
	add r0,r0,r8
	add r1,r1,r4

	bne BEGINYO


	ldmia sp!,{r4-r9,r15}


	endp

HPTPartialBltHO   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance

	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4}
	pld [r1]
	mov r2,r2, lsl #1
	mov r4,r4, lsl #1
	rsb r8,r2,#480
	sub r9,r4,r2
	add r4,r4,r2
BEGINYHO
	mov r6,r2
	pld [r1,r9]

BEGINXHO
		ldrh r7,[r1] , #-2
		subs r6,r6,#2
		strh r7,[r0]
		add r0,r0,#2
		bne BEGINXHO
	
	subs r3,r3,#1
	add r0,r0,r8
	add r1,r1,r4
	bne BEGINYHO

	ldmia sp!,{r4-r9,r15}

	endp


HPTPartialBltVO   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance
	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4}
	pld [r1]
	mov r2,r2, lsl #1
	mov r4,r4, lsl #1
	rsb r8,r2,#480
	mov r9,r4
	add r4,r4,r2
BLITOBEGINYVO
	mov r6,r2
	pld [r1,-r9]

BLITOBEGINXVO
		
		ldrh r7,[r1] , #2
		subs r6,r6,#2
		strh r7,[r0]
		add r0,r0,#2
		bne BLITOBEGINXVO

	subs r3,r3,#1
	add r0,r0,r8
	sub r1,r1,r4
	bne BLITOBEGINYVO

	ldmia sp!,{r4-r9,r15}

	endp

HPTPartialBltHVO   PROC
;r0 destination
;r1 source
;r2 x size
;r3 y size
;r4 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance
	mov r12,sp
	stmdb sp!,{r4-r9,r14}
	ldmia r12!,{r4}
	pld [r1]
	mov r2,r2, lsl #1
	mov r4,r4, lsl #1
	rsb r8,r2,#480
	add r9,r4,r2
	sub r4,r4,r2
BLITOBEGINYHVO
	mov r6,r2
	pld [r1,-r9]

BLITOBEGINXHVO
		
		ldrh r7,[r1] , #-2
		subs r6,r6,#2
		strh r7,[r0]
		add r0,r0,#2
		bne BLITOBEGINXHVO

	subs r3,r3,#1
	add r0,r0,r8
	sub r1,r1,r4
	bne BLITOBEGINYHVO

	ldmia sp!,{r4-r9,r15}

	endp

HPTBlt16x16O   PROC
;r0 destination
;r1 source
;r2 ystep
;r3 y size
;r4 color
;r5 ystep
;r6 current x size for current line
;r7 current pixel
;r8 amount to get to next line in back buffer
;r9 prefetch distance

	stmdb sp!,{r4-r11,r14}
	pld [r1]
	mov r3,#16
	mov r2,r2 LSL #1

BEGIN16x16O
	pld [r1,#32]
	ldrh r4,[r1]
	ldrh r5,[r1,#2]
	strh r4,[r0]
	ldrh r6,[r1,#4]
	strh r5,[r0,#2]
	ldrh r7,[r1,#6]
	strh r6,[r0,#4]
	ldrh r8,[r1,#8]
	strh r7,[r0,#6]
	ldrh r9,[r1,#10]
	strh r8,[r0,#8]
	ldrh r10,[r1,#12]
	strh r9,[r0,#10]
	ldrh r11,[r1,#14]
	strh r10,[r0,#12]
	strh r11,[r0,#14]
	
	ldrh r4,[r1,#16]
	ldrh r5,[r1,#18]
	strh r4,[r0,#16]
	ldrh r6,[r1,#20]
	strh r5,[r0,#18]
	ldrh r7,[r1,#22]
	strh r6,[r0,#20]
	ldrh r8,[r1,#24]
	subs r3,r3,#1
	strh r7,[r0,#22]
	ldrh r9,[r1,#26]
	strh r8,[r0,#24]
	ldrh r10,[r1,#28]
	strh r9,[r0,#26]
	ldrh r11,[r1,#30]
	strh r10,[r0,#28]
	strh r11,[r0,#30]

	add r1,r1,r2
	add r0,r0,#480
	bne BEGIN16x16O


	ldmia sp!,{r4-r11,r15}

	endp

MemCpyFastLandscape   PROC
;r0 destination
;r1 source
;r2 current destination
;r3 y count
;r4 x count
;r5-r8 registers to hold data
;r9-r11 registers to hold output offsets

	stmdb sp!,{r4-r11,r14}

	mov r3,#0
	;sub r3,r3,#2
	mov r4,#60
	;mov r9,#640
	add r9,r2,#640
	mov r10,r9 LSL #1
	add r11,r9,r10

	;mov r2,r0
BEGINLANDSCAPEY
	sub r2,r0,r3
	add r3,r3,#2
	pld [r1,#64]

BEGINLANDSCAPEX
	ldrh r5,[r1]
	ldrh r6,[r1,#2]
	ldrh r7,[r1,#4]
	ldrh r8,[r1,#6]
	add r1,r1,#8
	subs r4,r4,#1
	strh r5,[r2]
	strh r6,[r2,r9]
	strh r7,[r2,r10]
	strh r8,[r2,r11]
	add r2,r2,r11
	add r2,r2,r9
	bne BEGINLANDSCAPEX

	cmp r3,#640
	mov r4,#60
	bne BEGINLANDSCAPEY

	ldmia sp!,{r4-r11,r15}

	endp

	END
