/*string constants*/
	.section .rodata
	.align 2
print:
	.asciz "%s"
	.align 2
summary:
	.asciz "Summary: \n\t%d characters\n\t%d words\n\t%d lines\n"

/*global variable*/
	.data
	.align 2
dat:                            @ global variable dat of type  struct try
        .word   0               @ member val of type int
        .word   0               @ member str of type int
        .word   0               @ member str of type int
        .word   0               @ member str of type int
        .word   0               @ member str of type int
        _inchar = 0             @ _inchar is offset for member inchar
        _outchar = 4            @ _outchar is offset for member outchar
        _charct = 8             @ _charct is offset for member charct
        _wordct = 12            @ _wordct is offset for member wordct
        _linect = 16            @ _lincect is offset for member linect

        .align 2
buff:   .skip   100

/*functions*/
	.text
get_description:
	push	{fp, lr}	@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8	@ two local variables
	@ [fp, #-12] holds buffP, pointer to buff
	@ [fp, #-8] holds dp, pointer to variable of type struct transdat
	@ r4 holds copy of pointer dp

	str	r0, [fp, #-8]	@ intialize argument dp
	str	r1, [fp, #-12]	@ initialize buffP

	push	{r4}		@ save and initialize r4
	ldr	r4, [fp, #-8]

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 0)
	mov	r1, #0
	bl 	get_byte

	mov	r1, #0		@ if get_byte(buff, 0) == 0
	cmp	r0, r1
	beq	true

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 1)
	mov	r1, #1
	bl	get_byte

	mov	r1, #' '	@ if get_byte(buff, 1) != ' '
	cmp	r0, r1
	bne	true

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 2)
	mov	r1, #2
	bl	get_byte

	mov	r1, #0		@ if get_byte(buff, 2) == 0
	cmp	r0, r1
	beq	true

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 3)
	mov	r1, #3
	bl	get_byte

	mov	r1, #'\n'	@ if get_byte(buff, 3) != '\n'
	cmp	r0, r1
	bne	true

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 4)
	mov	r1, #4
	bl	get_byte

	mov	r1, #0		@ if get_byte(buff, 4) != 0
	cmp	r0, r1
	bne	true

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 0)
	mov	r1, #0
	bl	get_byte

	str	r0, [r4, #_inchar]	@ store return value in inchar

	ldr	r0, [fp, #-12]	@ call get_byte(buff, 2)
	mov	r1, #2
	bl	get_byte

	str	r0, [r4, #_outchar]	@ store return value in outchar

	mov	r0, #1

	b	next

true:
	mov	r0, #0

next:
	pop	{r4}		@ restore value of r4
	sub	sp, fp, #4	@ tear down stack frame
	pop	{fp, pc}

translate:
        push    {fp, lr}        @ setup stack frame
        add     fp, sp, #4
        sub     sp, sp, #16      @ three local variables
        @ [fp, #-12] holds buffP, pointer to buff
        @ [fp, #-8] holds dp, pointer to variable of type struct transdat
        @ [fp, #-16] holds indx, int for the index of buffP
	@ [fp, #-20] holds in_word, boolean to deteermine whether we are in a word or not
	@ r4 holds copy of pointer dp
	@ r5 holds dp->inchar, char to be replaced
	@ r6 holds dp->outchar, char to replace inchar
	@ r7 holds dp->charct, the count of cars in buff
	@ r8 holds indx, int for index of buffP

        str     r0, [fp, #-8]   @ intialize argument dp
	str	r1, [fp, #-12]	@ initialize buffP
	str	r2, [fp, #-20]	@ initialize in_word

        push    {r4, r5, r6, r7, r8}    @ save registers
        ldr     r4, [fp, #-8]		@ initialize dp
	ldr	r5, [r4, #_inchar]	@ initialize inchar
	ldr	r6, [r4, #_outchar]	@ initialize outchar
	ldr	r7, [r4, #_charct]	@ initialize charct
	str	r8, [fp, #-16]		@ initialize indx

	mov	r8, #0			@ store 0 in indx

	mov	r0, #0
	str	r0, [fp, #-20]

	b	guard

body:
	ldr	r0, [fp, #-12]	@ call get_byte(buff, indx)
	mov	r1, r8
	bl	get_byte

	cmp	r0, r5		@ if (buff[index] == inchar)
	bne	next1

        ldr     r0, [fp, #-12]  @ call put_byte(buff, index, outchar)
        mov	r1, r8
        mov     r2, r6
        bl      put_byte

next1:
        ldr     r0, [fp, #-12]  @ call get_byte(buff, indx)
        mov     r1, r8
        bl      get_byte

	cmp	r0, #'\n'	@ if get_byte = '\n'
	bne	next2

	ldr	r0, [r4, #_linect]	@ increment linect
	add	r0, r0, #1
	str	r0, [r4, #_linect]

next2:
        ldr     r0, [fp, #-12]  @ call get_byte(buff, indx)
        mov     r1, r8
        bl      get_byte

	cmp	r0, #' '	@ if get_byte == ' '
	bne	next3

	ldr	r0, [fp, #-20]	@ if in_word == 1
	cmp	r0, #1
	bne	next3

	mov	r0, #0		@ in_word = 0
	str	r0, [fp, #-20]

next3:
        ldr     r0, [fp, #-12]  @ call get_byte(buff, indx)
        mov     r1, r8
        bl      get_byte

	mov	r1, r0		@ store the value in r1

	mov	r0, r1		@ call is_upper(get_byte(buff, indx))
	bl	is_upper

	cmp	r0, #1		@ if return == 1, go to true
	beq	true1

	mov	r0, r1		@ call is_lower(get_byte(buff, indx))
	bl	is_lower

	cmp	r0, #1		@ if return != 1, go to next
	bne	next4

true1:
	ldr	r0, [fp, #-20]	@ if in_word == 0
	cmp	r0, #0
	bne	next4

	ldr	r0, [r4, #_wordct]	@ increment wordct
	add	r0, r0, #1
	str	r0, [r4, #_wordct]

	mov	r0, #1		@ in_word = 1
	str	r0, [fp, #-20]

next4:
	add	r8, r8, #1		@ increment indx

	add	r7, r7, #1		@ increment charct

guard:
        ldr     r0, [fp, #-12]  @ call get_byte(buff, indx)
        mov     r1, r8
        bl      get_byte

        cmp     r0, #0
        bne     body

	str	r7, [r4, #_charct]

	ldr	r0, [fp, #-12]	@ return buff
	pop	{r4, r5, r6, r7, r8}	@ restore value of r4, r5, r6, r7, r8
	sub	sp, fp, #4	@ tear down stack frame
	pop	{fp, pc}

print_summary:
        push    {fp, lr}        @ setup stack frame
        add     fp, sp, #4
        sub     sp, sp, #8      @ one local variables
        @ [fp, #-8] holds dp, pointer to variable of type struct transdat
        @ r4 holds copy of pointer dp

        str     r0, [fp, #-8]   @ intialize argument dp

        push    {r4}            @ save and initialize r4
        ldr     r4, [fp, #-8]

	ldr	r0, summaryP	@ print summary
	ldr	r1, [r4, #_charct]
	ldr	r2, [r4, #_wordct]
	ldr	r3, [r4, #_linect]
	bl	printf

	mov	r0, #0		@ return 0
	pop	{r4}		@ restore values of r4
	sub	sp, fp, #4	@ tear down stack frame
	pop	{fp, pc}

is_lower:
        push    {fp, lr}        @ setup stack frame
        add     fp, sp, #4
        sub     sp, sp, #8      @ one variable
        @ [fp, #-8] holds c, a character

        str     r0, [fp, #-8]   @ initialize c

        ldr     r0, [fp, #-8]   @ if c > 96 && c < 123
        cmp     r0, #96
        ble     else1

        ldr     r0, [fp, #-8]
        cmp     r0, #123
        bge     else1

        mov     r0, #1          @ return 1

        b       next5

else1:
        mov     r0, #0          @ return 0

next5:
        sub     sp, fp, #4      @ tear down stack frame
        pop     {fp, pc}


is_upper:
	push	{fp, lr}	@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8	@ one variable
	@ [fp, #-8] holds c, a character

	str	r0, [fp, #-8]	@ initialize c

	ldr	r0, [fp, #-8]	@ if c > 64 && c < 91
	cmp	r0, #64
	ble	else2

	ldr	r0, [fp, #-8]
	cmp	r0, #91
	bge	else2

	mov	r0, #1		@ return 1

	b	next6

else2:
	mov	r0, #0		@ return 0

next6:
	sub	sp, fp, #4	@ tear down stack frame
	pop	{fp, pc}

/*main program*/
	.text
	.align 2
	.global main
main:
	push	{fp, lr}	@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8	@ one local variables
	@ [fp, #-8] holds dp, pointer to variable of type struct transdat
	@ r4 holds copy of the pointer dp

	push	{r4}		@ save and initialize r4
	ldr	r4, datP	@ assign address of dat to r4

	str	r4, [fp, #-8]	@ initialize local variable dp

	ldr	r0, buffP	@ call get_line(buff, 100)
	mov	r1, #100
	bl	get_line

	ldr	r0, [fp, #-8] 	@ call get_description(dp, buff)
	ldr	r1, buffP
	bl	get_description

	b	guard1

body1:
	ldr     r0, [fp, #-8]   @ call translate(dp, buff)
        ldr     r1, buffP
        bl      translate

        ldr     r0, printP     	@ print buff
        ldr     r1, buffP
        bl      printf

guard1:
	ldr	r0, buffP	@ call get_line(buff, 100)
	mov	r1, #100
	bl	get_line

	cmp	r0, #1		@ if get_line(buff, max) >= 1
	bge	body1

	ldr	r0, [fp, #-8]
	bl	print_summary

	mov	r0, #0		@ return 0
	pop	{r4}		@ restore value of r4
	sub	sp, fp, #4	@ tear down stack frame
	pop	{fp, pc}


/*pointer variables*/
	.align 2
printP:		.word print
buffP:		.word buff
datP:		.word dat
summaryP:	.word summary
