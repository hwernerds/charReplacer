/* example of using a global struct
   requires hdlib */

	.data
/* global variables */
	.align 2
buff:				@ global char* variable
	.asciz "Hello"

	.align 2
dat:				@ global variable dat of type  struct try
	.word	0		@ member val of type int
	.word	0		@ member str of type int
        .word   0               @ member str of type int
        .word   0               @ member str of type int
        .word   0               @ member str of type int
	_inchar = 0		@ _inchar is offset for member inchar
	_outchar = 4		@ _outchar is offset for member outchar
	_charct = 8		@ _charct is offset for member charct
	_wordct = 12		@ _wordct is offset for member wordct
	_linect = 16		@ _lincect is offset for member linect

/* function mod
      1 arg - pointer to a variable of type  struct try
      state change - add 1 to arg1->val and assign 'X' to arg1->str[1]
      return - integer, value of arg1->val */
	.text
mod:
	push	{fp, lr}		@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8		@ one local variable
	@ [fp, #-8] holds dp, pointer to variable of type  struct try
	@ r4 holds copy of the pointer dp

	str	r0, [fp, #-8]		@ initialize argument dp

	push	{r4}			@ save and initialize r4
	ldr	r4, [fp, #-8]

	ldr	r1, [r4, #_inchar]	@ add 100 to dp->inchar
	add	r1, r1, #100
	str	r1, [r4, #_inchar]

	ldr     r1, [r4, #_outchar]     @ add 100 to dp->outchar
        add     r1, r1, #100
        str     r1, [r4, #_outchar]

        ldr     r1, [r4, #_charct]      @ add 100 to dp->charct
        add     r1, r1, #100
        str     r1, [r4, #_charct]

        ldr     r1, [r4, #_wordct]      @ add 100 to dp->wordct
        add     r1, r1, #100
        str     r1, [r4, #_wordct]

        ldr     r1, [r4, #_linect]      @ add 100 to dp->linect
        add     r1, r1, #100
        str     r1, [r4, #_linect]


	ldr	r0, [r4, #_inchar]	@ return dp->inchar
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* format strings */
	.section .rodata
	.align 2
return:					@ format string for return value
	.asciz "mod(dp) returned %d\n"
	.align 2
dump1:					@ format string for dat members
	.asciz "dat holds {%d, %d, %d, "
	.align 2
dump2:
	.asciz "%d, %d}\n"

/* function main */
	.text
	.global main
	.align 4
main:
	push	{fp, lr}		@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8		@ two local variables
	@ [fp, #-8] holds dp, pointer to variable of type  struct transdat
	@ [fp, #-12] holds ret, return value from mod()
	@ r4 holds copy of the pointer dp

	push	{r4}			@ save and initialize r4
	ldr	r4, datP		@ assign address of dat to r4

	str	r4, [fp, #-8]		@ initialize local variable dp
	mov	r1, #10			@ store 10 in dp->inchar
	str	r1, [r4, #_inchar]
	mov	r1, #11			@ store 11 in dp->outchar
	str	r1, [r4, #_outchar]
	mov	r1, #12			@ store 12 in dp->charct
	str	r1, [r4, #_charct]
	mov	r1, #13			@ store 13 in dp->wordct
	str	r1, [r4, #_wordct]
	mov	r1, #14			@ store 14 in dp->linect
	str	r1, [r4, #_linect]

	ldr	r0, dumpP1		@ print labelled members of *dp
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	ldr	r3, [r4, #_charct]
	bl	printf

	ldr	r0, dumpP2
	ldr	r1, [r4, #_wordct]
	ldr	r2, [r4, #_linect]
	bl	printf

	ldr	r0, [fp, #-8]		@ call mod(dp)
	bl	mod
	str	r0, [fp, #-12]		@ store return value in ret

	ldr	r0, returnP		@ print labelled return value
	ldr	r1, [fp, #-12]
	bl	printf

	ldr	r0, dumpP1		@ print labelled members of *dp
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	ldr	r3, [r4, #_charct]
	bl	printf

	ldr	r0, dumpP2
	ldr	r1, [r4, #_wordct]
	ldr	r2, [r4, #_linect]
	bl	printf

	mov	r0, #0			@ return 0
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* pointer variables */

	.align 2
buffP:		.word buff
datP:		.word dat
returnP:	.word return
dumpP1:		.word dump1
dumpP2:		.word dump2
