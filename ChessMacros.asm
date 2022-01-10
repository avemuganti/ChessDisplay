
############################## DRAW SQUARE ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the base address.

.macro	draw_square(%x, %y, %c, %m) 

add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %c
add	$t3, $zero, %m
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t3, $t3, $t0
add	$t3, $t3, $t1

# Now, the base address of the square should be correct.

li	$t4, 0
loopDrawSquareOuter:
li	$t5, 0
loopDrawSquareInner:
sw	$t2, ($t3)
addi	$t3, $t3, 4
addi	$t5, $t5, 1
bge	$t5, 16, endLoopDrawSquareInner
j	loopDrawSquareInner
endLoopDrawSquareInner:
addi	$t3, $t3, 448
addi	$t4, $t4, 1
bge	$t4, 16, endLoopDrawSquareOuter
j	loopDrawSquareOuter
endLoopDrawSquareOuter:

.end_macro

############################## DRAW BOARD ##################################

# m is the base address, w is the color for white, b is the color for black. 

.macro	draw_board(%m, %w, %b, %hw, %hb)

subi	$a2, $s7, 64
subi	$a3, $s7, 128
li	$t0, 0
loopDrawBoardOuter:
li	$t1, 0
loopDrawBoardInner:
add	$t2, $t0, $t1
div	$t2, $t2, 2
mfhi	$t2
subi	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
beqz	$t2, drawWhiteSquare
# Draw black square
move	$a0, $t0
move	$a1, $t1
subi	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
compare_square($a0, $a1, $a2, $a3)
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
beqz	$v0, highlightBlack
move	$a0, $t0
move	$a1, $t1
draw_square($a0, $a1, %b, %m)
j	afterDrawSquare
highlightBlack:
move	$a0, $t0
move	$a1, $t1
draw_square($a0, $a1, %hb, %m)
j	afterDrawSquare
drawWhiteSquare:
# Draw white square
move	$a0, $t0
move	$a1, $t1
subi	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
compare_square($a0, $a1, $a2, $a3)
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
beqz	$v0, highlightWhite
move	$a0, $t0
move	$a1, $t1
draw_square($a0, $a1, %w, %m)
j	afterDrawSquare
highlightWhite:
move	$a0, $t0
move	$a1, $t1
draw_square($a0, $a1, %hw, %m)
afterDrawSquare:
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
addi	$t1, $t1, 1
bge	$t1, 8, endLoopDrawBoardInner
j	loopDrawBoardInner
endLoopDrawBoardInner:
addi	$t0, $t0, 1
bge	$t0, 8, endLoopDrawBoardOuter
j	loopDrawBoardOuter
endLoopDrawBoardOuter:

.end_macro

############################## DRAW BOARD B ##################################

# m is the base address, w is the color for white, b is the color for black. Same as draw board, but draws the board upside down.

.macro	draw_board_b(%m, %w, %b, %hw, %hb)

subi	$a2, $s7, 64
subi	$a3, $s7, 128
li	$t6, 7
li	$t0, 0 # Outer loop counter
loopDrawBoardOuter:
li	$t1, 0 # Inner loop counter
loopDrawBoardInner:
add	$t2, $t0, $t1
div	$t2, $t2, 2
mfhi	$t2
subi	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
beqz	$t2, drawWhiteSquare
# Draw black square
move	$a0, $t0
move	$a1, $t1
subi	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
compare_square($a0, $a1, $a2, $a3)
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
beqz	$v0, highlightBlack
sub	$a0, $t6, $t0
sub	$a1, $t6, $t1
draw_square($a0, $a1, %b, %m)
j	afterDrawSquare
highlightBlack:
sub	$a0, $t6, $t0
sub	$a1, $t6, $t1
draw_square($a0, $a1, %hb, %m)
j	afterDrawSquare
drawWhiteSquare:
# Draw white square
move	$a0, $t0
move	$a1, $t1
subi	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
compare_square($a0, $a1, $a2, $a3)
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
beqz	$v0, highlightWhite
sub	$a0, $t6, $t0
sub	$a1, $t6, $t1
draw_square($a0, $a1, %w, %m)
j	afterDrawSquare
highlightWhite:
sub	$a0, $t6, $t0
sub	$a1, $t6, $t1
draw_square($a0, $a1, %hw, %m)
afterDrawSquare:
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
addi	$t1, $t1, 1
bge	$t1, 8, endLoopDrawBoardInner
j	loopDrawBoardInner
endLoopDrawBoardInner:
addi	$t0, $t0, 1
bge	$t0, 8, endLoopDrawBoardOuter
j	loopDrawBoardOuter
endLoopDrawBoardOuter:

.end_macro

############################## DRAW PAWN ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the bitmap base address.

.macro	draw_pawn(%x, %y, %c, %m)

.data
pawnIcon:	.byte	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,
			0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0,
			0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0,
			0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0,
			0,0,0,0,0,1,1,2,2,1,1,0,0,0,0,0,
			0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0,
			0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0,
			0,0,0,0,1,1,1,2,2,1,1,1,0,0,0,0,
			0,0,0,1,1,2,2,2,2,2,2,1,1,0,0,0,
			0,0,1,1,2,2,2,2,2,2,2,2,1,1,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
# First find the base address of the given square.
add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %m
add	$t3, $zero, %c
la	$t4, pawnIcon
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t2, $t2, $t0
add	$t2, $t2, $t1

li	$t0, 0
loopDrawPawnOuter:
li	$t1, 0
loopDrawPawnInner:
lb	$t5, ($t4)
beq	$t5, 1, drawPawnOutline
beq	$t5, 2, drawPawnInside
afterDrawPixelPawn:
addi	$t1, $t1, 1
addi	$t4, $t4, 1
addi	$t2, $t2, 4
bge	$t1, 16, endLoopDrawPawnInner
j	loopDrawPawnInner
endLoopDrawPawnInner:
addi	$t2, $t2, 448
addi	$t0, $t0, 1
bge	$t0, 16, endLoopDrawPawnOuter
j	loopDrawPawnOuter

drawPawnOutline:
sw	$zero, ($t2)
j	afterDrawPixelPawn

drawPawnInside:
sw	$t3, ($t2)
j	afterDrawPixelPawn

endLoopDrawPawnOuter:

.end_macro

############################## DRAW ROOK ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the bitmap base address.

.macro	draw_rook(%x, %y, %c, %m)

.data
rookIcon:	.byte	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,1,1,1,0,1,1,1,1,0,1,1,1,0,0,
			0,0,1,2,1,0,1,2,2,1,0,1,2,1,0,0,
			0,0,1,2,1,1,1,2,2,1,1,1,2,1,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
# First find the base address of the given square.
add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %m
add	$t3, $zero, %c
la	$t4, rookIcon
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t2, $t2, $t0
add	$t2, $t2, $t1

li	$t0, 0
loopDrawRookOuter:
li	$t1, 0
loopDrawRookInner:
lb	$t5, ($t4)
beq	$t5, 1, drawRookOutline
beq	$t5, 2, drawRookInside
afterDrawPixelRook:
addi	$t1, $t1, 1
addi	$t4, $t4, 1
addi	$t2, $t2, 4
bge	$t1, 16, endLoopDrawRookInner
j	loopDrawRookInner
endLoopDrawRookInner:
addi	$t2, $t2, 448
addi	$t0, $t0, 1
bge	$t0, 16, endLoopDrawRookOuter
j	loopDrawRookOuter

drawRookOutline:
sw	$zero, ($t2)
j	afterDrawPixelRook

drawRookInside:
sw	$t3, ($t2)
j	afterDrawPixelRook

endLoopDrawRookOuter:

.end_macro

############################## DRAW KNIGHT ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the bitmap base address.

.macro	draw_knight(%x, %y, %c, %m)

.data
knightIcon:	.byte	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,1,2,1,1,0,0,0,0,0,0,0,
			0,0,0,0,1,2,2,2,2,1,0,0,0,0,0,0,
			0,0,0,1,2,2,1,2,2,2,1,0,0,0,0,0,
			0,0,1,2,2,2,2,2,2,2,2,1,0,0,0,0,
			0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,0,
			0,0,1,2,2,1,1,2,2,2,2,2,1,0,0,0,
			0,0,0,1,1,0,0,1,2,2,2,2,1,0,0,0,
			0,0,0,0,0,0,1,1,2,2,2,2,1,0,0,0,
			0,0,0,0,0,1,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,1,1,0,0,0,0,
			0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
# First find the base address of the given square.
add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %m
add	$t3, $zero, %c
la	$t4, knightIcon
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t2, $t2, $t0
add	$t2, $t2, $t1

li	$t0, 0
loopDrawKnightOuter:
li	$t1, 0
loopDrawKnightInner:
lb	$t5, ($t4)
beq	$t5, 1, drawKnightOutline
beq	$t5, 2, drawKnightInside
afterDrawPixelKnight:
addi	$t1, $t1, 1
addi	$t4, $t4, 1
addi	$t2, $t2, 4
bge	$t1, 16, endLoopDrawKnightInner
j	loopDrawKnightInner
endLoopDrawKnightInner:
addi	$t2, $t2, 448
addi	$t0, $t0, 1
bge	$t0, 16, endLoopDrawKnightOuter
j	loopDrawKnightOuter

drawKnightOutline:
sw	$zero, ($t2)
j	afterDrawPixelKnight

drawKnightInside:
sw	$t3, ($t2)
j	afterDrawPixelKnight

endLoopDrawKnightOuter:

.end_macro

############################## DRAW BISHOP ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the bitmap base address.

.macro	draw_bishop(%x, %y, %c, %m)

.data
bishopIcon:	.byte	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,
			0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0,
			0,0,0,0,0,1,2,2,1,0,0,0,0,0,0,0,
			0,0,0,0,0,1,2,1,0,0,1,0,0,0,0,0,
			0,0,0,0,1,2,2,1,0,1,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,1,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,1,2,2,2,2,1,1,0,0,0,0,
			0,0,0,0,0,1,1,2,2,1,1,0,0,0,0,0,
			0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
# First find the base address of the given square.
add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %m
add	$t3, $zero, %c
la	$t4, bishopIcon
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t2, $t2, $t0
add	$t2, $t2, $t1

li	$t0, 0
loopDrawBishopOuter:
li	$t1, 0
loopDrawBishopInner:
lb	$t5, ($t4)
beq	$t5, 1, drawBishopOutline
beq	$t5, 2, drawBishopInside
afterDrawPixelBishop:
addi	$t1, $t1, 1
addi	$t4, $t4, 1
addi	$t2, $t2, 4
bge	$t1, 16, endLoopDrawBishopInner
j	loopDrawBishopInner
endLoopDrawBishopInner:
addi	$t2, $t2, 448
addi	$t0, $t0, 1
bge	$t0, 16, endLoopDrawBishopOuter
j	loopDrawBishopOuter

drawBishopOutline:
sw	$zero, ($t2)
j	afterDrawPixelBishop

drawBishopInside:
sw	$t3, ($t2)
j	afterDrawPixelBishop

endLoopDrawBishopOuter:

.end_macro

############################## DRAW QUEEN ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the bitmap base address.

.macro	draw_queen(%x, %y, %c, %m)

.data
queenIcon:	.byte	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,
			0,0,0,0,1,2,1,0,0,1,2,1,0,0,0,0,
			0,0,0,0,1,2,1,0,0,1,2,1,0,0,0,0,
			0,0,0,0,1,2,1,0,0,1,2,1,0,0,0,0,
			0,1,1,1,2,2,2,1,1,2,2,2,1,1,1,0,
			0,1,2,2,1,2,2,2,2,2,2,1,2,2,1,0,
			0,1,1,2,2,1,2,2,2,2,1,2,2,1,1,0,
			0,0,0,1,2,2,2,2,2,2,2,2,1,0,0,0,
			0,0,0,1,2,2,2,2,2,2,2,2,1,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,0,1,2,2,2,2,2,2,1,0,0,0,0,
			0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
# First find the base address of the given square.
add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %m
add	$t3, $zero, %c
la	$t4, queenIcon
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t2, $t2, $t0
add	$t2, $t2, $t1

li	$t0, 0
loopDrawQueenOuter:
li	$t1, 0
loopDrawQueenInner:
lb	$t5, ($t4)
beq	$t5, 1, drawQueenOutline
beq	$t5, 2, drawQueenInside
afterDrawPixelQueen:
addi	$t1, $t1, 1
addi	$t4, $t4, 1
addi	$t2, $t2, 4
bge	$t1, 16, endLoopDrawQueenInner
j	loopDrawQueenInner
endLoopDrawQueenInner:
addi	$t2, $t2, 448
addi	$t0, $t0, 1
bge	$t0, 16, endLoopDrawQueenOuter
j	loopDrawQueenOuter

drawQueenOutline:
sw	$zero, ($t2)
j	afterDrawPixelQueen

drawQueenInside:
sw	$t3, ($t2)
j	afterDrawPixelQueen

endLoopDrawQueenOuter:

.end_macro

############################## DRAW KING ##################################

# x is the x location (0 - 7), y is the y location (0 - 7), c is the color, m is the bitmap base address.

.macro	draw_king(%x, %y, %c, %m)

.data
kingIcon:	.byte	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,
			0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,
			0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,
			0,0,0,1,1,1,0,1,1,0,1,1,1,0,0,0,
			0,0,1,2,2,2,1,1,1,1,2,2,2,1,0,0,
			0,1,2,2,2,2,2,1,1,2,2,2,2,2,1,0,
			0,1,2,2,2,2,2,1,1,2,2,2,2,2,1,0,
			0,1,2,2,2,2,2,1,1,2,2,2,2,2,1,0,
			0,1,1,2,2,2,2,1,1,2,2,2,2,1,1,0,
			0,0,1,1,2,2,2,1,1,2,2,2,1,1,0,0,
			0,0,0,1,2,2,2,1,1,2,2,2,1,0,0,0,
			0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
			0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0,
			0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
# First find the base address of the given square.
add	$t0, $zero, %x
add	$t1, $zero, %y
add	$t2, $zero, %m
add	$t3, $zero, %c
la	$t4, kingIcon
sll	$t0, $t0, 6
sll	$t1, $t1, 13
add	$t2, $t2, $t0
add	$t2, $t2, $t1

li	$t0, 0
loopDrawKingOuter:
li	$t1, 0
loopDrawKingInner:
lb	$t5, ($t4)
beq	$t5, 1, drawKingOutline
beq	$t5, 2, drawKingInside
afterDrawPixelKing:
addi	$t1, $t1, 1
addi	$t4, $t4, 1
addi	$t2, $t2, 4
bge	$t1, 16, endLoopDrawKingInner
j	loopDrawKingInner
endLoopDrawKingInner:
addi	$t2, $t2, 448
addi	$t0, $t0, 1
bge	$t0, 16, endLoopDrawKingOuter
j	loopDrawKingOuter

drawKingOutline:
sw	$zero, ($t2)
j	afterDrawPixelKing

drawKingInside:
sw	$t3, ($t2)
j	afterDrawPixelKing

endLoopDrawKingOuter:

.end_macro

############################## DRAW POSITION B ##################################

# p is the base address of a position, w is the color white, b is the color black, m is the base address of the bitmap.
# positions have 64 bytes. 1 is pawn, 2 is knight, 3 is bishop, 4 is rook, 5 is queen, 6 is king, 0 is nothing.
# negative numbers in positions represent black pieces, positive numbers represent white pieces.

.macro	draw_position_b(%p, %w, %b, %m)
# Same as draw position, but flipped.

add	$t6, $zero, %p
li	$t7, 7
loopDrawPositionOuter:
li	$t8, 7
loopDrawPositionInner:
lb	$t9, ($t6)
beq	$t9, -6, drawBlackKing
beq	$t9, -5, drawBlackQueen
beq	$t9, -4, drawBlackRook
beq	$t9, -3, drawBlackBishop
beq	$t9, -2, drawBlackKnight
beq	$t9, -1, drawBlackPawn
beq	$t9, 1, drawWhitePawn
beq	$t9, 2, drawWhiteKnight
beq	$t9, 3, drawWhiteBishop
beq	$t9, 4, drawWhiteRook
beq	$t9, 5, drawWhiteQueen
beq	$t9, 6, drawWhiteKing
afterDrawPiece:
subi	$t8, $t8, 1
addi	$t6, $t6, 1
bltz	$t8, endLoopDrawPositionInner
j	loopDrawPositionInner
endLoopDrawPositionInner:
subi	$t7, $t7, 1
bltz	$t7, endLoopDrawPositionOuter
j	loopDrawPositionOuter

drawBlackKing:
draw_king($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackQueen:
draw_queen($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackRook:
draw_rook($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackBishop:
draw_bishop($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackKnight:
draw_knight($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackPawn:
draw_pawn($t8, $t7, %b, %m)
j	afterDrawPiece

drawWhiteKing:
draw_king($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteQueen:
draw_queen($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteRook:
draw_rook($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteBishop:
draw_bishop($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteKnight:
draw_knight($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhitePawn:
draw_pawn($t8, $t7, %w, %m)
j	afterDrawPiece

endLoopDrawPositionOuter:

.end_macro

############################## DRAW POSITION ##################################

# p is the base address of a position, w is the color white, b is the color black, m is the base address of the bitmap.
# positions have 64 bytes. 1 is pawn, 2 is knight, 3 is bishop, 4 is rook, 5 is queen, 6 is king, 0 is nothing.
# negative numbers in positions represent black pieces, positive numbers represent white pieces.

.macro	draw_position(%p, %w, %b, %m)

add	$t6, $zero, %p
li	$t7, 0
loopDrawPositionOuter:
li	$t8, 0
loopDrawPositionInner:
lb	$t9, ($t6)
beq	$t9, -6, drawBlackKing
beq	$t9, -5, drawBlackQueen
beq	$t9, -4, drawBlackRook
beq	$t9, -3, drawBlackBishop
beq	$t9, -2, drawBlackKnight
beq	$t9, -1, drawBlackPawn
beq	$t9, 1, drawWhitePawn
beq	$t9, 2, drawWhiteKnight
beq	$t9, 3, drawWhiteBishop
beq	$t9, 4, drawWhiteRook
beq	$t9, 5, drawWhiteQueen
beq	$t9, 6, drawWhiteKing
afterDrawPiece:
addi	$t8, $t8, 1
addi	$t6, $t6, 1
bge	$t8, 8, endLoopDrawPositionInner
j	loopDrawPositionInner
endLoopDrawPositionInner:
addi	$t7, $t7, 1
bge	$t7, 8, endLoopDrawPositionOuter
j	loopDrawPositionOuter

drawBlackKing:
draw_king($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackQueen:
draw_queen($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackRook:
draw_rook($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackBishop:
draw_bishop($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackKnight:
draw_knight($t8, $t7, %b, %m)
j	afterDrawPiece

drawBlackPawn:
draw_pawn($t8, $t7, %b, %m)
j	afterDrawPiece

drawWhiteKing:
draw_king($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteQueen:
draw_queen($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteRook:
draw_rook($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteBishop:
draw_bishop($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhiteKnight:
draw_knight($t8, $t7, %w, %m)
j	afterDrawPiece

drawWhitePawn:
draw_pawn($t8, $t7, %w, %m)
j	afterDrawPiece

endLoopDrawPositionOuter:

.end_macro

############################## MOVE PIECE ##################################

# p is the position base address, xf and yf are the initial coords of the piece, xt and yt are the final coords of the piece.
# pr is the promotion tag. Is +- 2, 3, 4, or 5 depending on piece to promote to.
# uses the cache pointer to store the next position on the cache.
# -1 in pr is the black en passant flag, and +1 is the white en passant flag.
.macro	move_piece(%p, %xf, %yf, %xt, %yt, %pr)

# First we copy the position onto the cache, where we can modify it.
addi	$s5, $s5, 1
li	$t2, 0
add	$t0, $zero, %p
add	$t9, $zero, %pr
loopMovePiece:
lw	$t1, ($t0)
sw	$t1, ($s7)
addi	$t0, $t0, 4
addi	$s7, $s7, 4
addi	$t2, $t2, 1
bge	$t2, 16, endLoopMovePiece
j	loopMovePiece

# Now modify the position in cache memory.
endLoopMovePiece:
subi	$t0, $s7, 64
add	$t1, $zero, %xf
add	$t0, $t0, $t1
add	$t1, $zero, %yf
sll	$t1, $t1, 3
add	$t0, $t0, $t1 # Now the initial square should be found.
lb	$t1, ($t0) # Store the piece into t1.
sb	$zero, ($t0)
subi	$t0, $s7, 64 # Restore the original base address of the position in cache memory.
add	$t2, $zero, %xt
add	$t0, $t0, $t2
add	$t2, $zero, %yt
sll	$t2, $t2, 3
add	$t0, $t0, $t2 # Now the final square should be found.
bnez	$t9, promote
sb	$t1, ($t0) # Take the piece and put it at the desired location.
j	endPromotion
promote:
beq	$t9, 1, whiteEPMove
beq	$t9, -1, blackEPMove
beq	$t9, 6, whiteKingCastle
beq	$t9, 7, whiteQueenCastle
beq	$t9, -6, blackKingCastle
beq	$t9, -7, blackQueenCastle
sb	$t9, ($t0)
j	endPromotion
whiteEPMove:
sb	$t1, ($t0)
sb	$zero, 8($t0)
j	endPromotion
blackEPMove:
sb	$t1, ($t0)
sb	$zero, -8($t0)
j	endPromotion
whiteKingCastle:
sb	$t1, ($t0)
subi	$t0, $s7, 64 # Restore the original base address of the position in cache memory.
sb	$zero, 63($t0)
li	$t1, 4
sb	$t1, 61($t0)
j	endPromotion
whiteQueenCastle:
sb	$t1, ($t0)
subi	$t0, $s7, 64 # Restore the original base address of the position in cache memory.
sb	$zero, 56($t0)
li	$t1, 4
sb	$t1, 59($t0)
j	endPromotion
blackKingCastle:
sb	$t1, ($t0)
subi	$t0, $s7, 64 # Restore the original base address of the position in cache memory.
sb	$zero, 7($t0)
li	$t1, -4
sb	$t1, 5($t0)
j	endPromotion
blackQueenCastle:
sb	$t1, ($t0)
subi	$t0, $s7, 64 # Restore the original base address of the position in cache memory.
sb	$zero, ($t0)
li	$t1, -4
sb	$t1, 3($t0)
j	endPromotion
endPromotion:

.end_macro

############################## POP POSITION ##################################

# Pops a position off of the cache.
.macro pop_position

subi	$s5, $s5, 1
li	$t0, 0 # The loop counter
loopPopPosition:
subi	$s7, $s7, 4
sw	$zero, ($s7)
addi	$t0, $t0, 1
bge	$t0, 16, endLoopPopPosition
j	loopPopPosition
endLoopPopPosition:

.end_macro

############################## ENCACHE POSITION ##################################

# Puts the position which is at base address p onto the cache.
.macro encache_position(%p)

add	$t0, $zero, %p
li	$t1, 0
loopEncache:
lw	$t2, ($t0)
sw	$t2, ($s7)
addi	$t0, $t0, 4
addi	$s7, $s7, 4
addi	$t1, $t1, 1
bge	$t1, 16, endLoopEncache
j	loopEncache
endLoopEncache:
addi	$s5, $s5, 1

.end_macro

############################## COUNT MOVES WHITE ##################################

# Counts the number of available moves for the white player.
.macro count_moves_white(%p, %lp)

gen_pos_white(%p, %lp, 1000)
move	$v0, $v1

.end_macro

############################## COUNT MOVES BLACK ##################################

# Counts the number of available moves for the black player.
.macro count_moves_black(%p, %lp)

gen_pos_black(%p, %lp, 1000)
move	$v0, $v1

.end_macro

############################## WHITE IN CHECKMATE ##################################

# returns 0 if white is not in checkmate, and 1 if white is in checkmate.
.macro white_in_checkmate (%p, %lp)

count_moves_white(%p, %lp)
move	$t0, $v0
subi	$sp, $sp, 4
sw	$t0, ($sp)
white_in_check(%p)
lw	$t0, ($sp)
addi	$sp, $sp, 4
move	$t1, $v0
bnez	$t0, notWhiteMate
bne	$t1, 1, notWhiteMate
li	$v0, 1
j	endWhiteMate
notWhiteMate:
li	$v0, 0
endWhiteMate:

.end_macro

############################## BLACK IN CHECKMATE ##################################

# returns 0 if black is not in checkmate, and 1 if black is in checkmate.
.macro black_in_checkmate (%p, %lp)

count_moves_black(%p, %lp)
move	$t0, $v0
subi	$sp, $sp, 4
sw	$t0, ($sp)
black_in_check(%p)
lw	$t0, ($sp)
addi	$sp, $sp, 4
move	$t1, $v0
bnez	$t0, notBlackMate
bne	$t1, 1, notBlackMate
li	$v0, 1
j	endBlackMate
notBlackMate:
li	$v0, 0
endBlackMate:

.end_macro

############################## WHITE IN STALEMATE ##################################

# returns 0 if white is not in stalemate, and 1 if white is in stalemate.
.macro white_in_stalemate (%p, %lp)

count_moves_white(%p, %lp)
move	$t0, $v0
subi	$sp, $sp, 4
sw	$t0, ($sp)
white_in_check(%p)
lw	$t0, ($sp)
addi	$sp, $sp, 4
move	$t1, $v0
bnez	$t0, notWhiteSMate
bnez	$t1, notWhiteSMate
li	$v0, 1
j	endWhiteSMate
notWhiteSMate:
li	$v0, 0
endWhiteSMate:

.end_macro

############################## BLACK IN STALEMATE ##################################

# returns 0 if black is not in stalemate, and 1 if black is in stalemate.
.macro black_in_stalemate (%p, %lp)

count_moves_black(%p, %lp)
move	$t0, $v0
subi	$sp, $sp, 4
sw	$t0, ($sp)
black_in_check(%p)
lw	$t0, ($sp)
addi	$sp, $sp, 4
move	$t1, $v0
bnez	$t0, notBlackSMate
bnez	$t1, notBlackSMate
li	$v0, 1
j	endBlackSMate
notBlackSMate:
li	$v0, 0
endBlackSMate:

.end_macro

############################## ARE EQUAL ##################################

# returns 1 if the two positions are equivalent to one another. p1 and p2 are both base addresses.
.macro	are_equal(%p1, %p2)

add	$t0, $zero, %p1
add	$t1, $zero, %p2
li	$t2, 0 # The loop counter
loopAreEqual:
lw	$t3, ($t0)
lw	$t4, ($t1)
bne	$t3, $t4, notEqual
addi	$t2, $t2, 1
addi	$t0, $t0, 4
addi	$t1, $t1, 4
bge	$t2, 16, equal
j	loopAreEqual
notEqual:
li	$v0, 0
j	endEqual
equal:
li	$v0, 1
endEqual:

.end_macro

############################## DRAW BY REPETITION ##################################

# returns 0 in v0 if there is no draw by repetition, and 1 if there is.
.macro	draw_by_repetition

sll	$t0, $s5, 6
sub	$t0, $s7, $t0 # The base address of the whole cache is now in t0.
li	$t1, 0 # Outer loop counter
outerRepetition:
subi	$t2, $s5, 1
bge	$t1, $t2, endOuterRepetition
sll	$t3, $t1, 6
add	$t3, $t0, $t3 # The base address of the position in question is now in t3.
addi	$t4, $t1, 1 # Inner loop counter
li	$t5, 0 # Keeps track of number of repeats.
innerRepetition:
bge	$t4, $s5, endInnerRepetition
sll	$t6, $t4, 6
add	$t6, $t0, $t6 # The base address of the second position is now in t6.
move	$a0, $t3
move	$a1, $t6
subi	$sp, $sp, 28
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
sw	$t6, 24($sp)
are_equal($a0, $a1)
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
lw	$t6, 24($sp)
addi	$sp, $sp, 28
beq	$v0, 1, addRepeats
afterAddRepeats:
bge	$t5, 2, repeatFound
addi	$t4, $t4, 1
j	innerRepetition
endInnerRepetition:
addi	$t1, $t1, 1
j	outerRepetition
endOuterRepetition:
j	repeatNotFound

addRepeats:
addi	$t5, $t5, 1
j	afterAddRepeats

repeatFound:
li	$v0, 1
j	endRepetition
repeatNotFound:
li	$v0, 0
endRepetition:

.end_macro

############################## FIFTY MOVE RULE ##################################

# returns 1 in v0 if the game is a draw by the fifty move rule. # Note that fifty moves is 100 positions.
.macro	fifty_move_rule

sll	$t0, $s5, 6
sub	$t0, $s7, $t0 # The base address of the relevant cache is now in t0.
li	$t2, 0 # The number of move pairs without a pawn move. Is a drawn position if this is at least 100.
li	$t3, 0 # The number of move pairs without a capture. Is a drawn position if this is at least 100.
subi	$t1, $s5, 1 # The number of times we loop. Also serves as an inverted outer loop counter.
# Go through every adjacent pair of positions in the cache. 
outerFifty:
beqz	$t1, endOuterFifty
li	$t5, 0 # The inner loop counter.
li	$t8, 0 # The difference in number of pieces on the board between two positions of the pair.
li	$t4, 0 # The pawn move flag. If there is a pawn move, this should be 1.
innerFifty:
add	$t9, $t0, $t5 # Gives the address that we want for this square.
lb	$t6, ($t9)
lb	$t7, 64($t9)
bnez	$t6, addFirstNumPieces
afterFirstNumPieces:
bnez	$t7, addSecondNumPieces
afterSecondNumPieces:
beq	$t6, 1, testPawnEquality
beq	$t6, -1, testPawnEquality
afterTestPawnEquality:
addi	$t5, $t5, 1
bge	$t5, 64, endInnerFifty
j	innerFifty
endInnerFifty: # Now we should have the pawn move flag, as well as the difference in piece count.
beqz	$t4, noPawnMove
li	$t2, 0
afterNoPawnMove:
beqz	$t8, noCaptures
li	$t3, 0
afterNoCaptures: # Check for draw.
bge	$t2, 100, drawByFiftyMove
bge	$t3, 100, drawByFiftyMove
addi	$t0, $t0, 64
subi	$t1, $t1, 1
j	outerFifty

addFirstNumPieces:
addi	$t8, $t8, 1
j	afterFirstNumPieces

addSecondNumPieces:
subi	$t8, $t8, 1
j	afterSecondNumPieces

testPawnEquality:
bne	$t6, $t7, pawnMoveDetected
j	afterTestPawnEquality

pawnMoveDetected:
li	$t4, 1
j	afterTestPawnEquality

noPawnMove:
addi	$t2, $t2, 1
j	afterNoPawnMove

noCaptures:
addi	$t3, $t3, 1
j	afterNoCaptures

endOuterFifty:
li	$v0, 0
j	afterDrawByFifty
drawByFiftyMove:
li	$v0, 1
afterDrawByFifty:

.end_macro

############################## DRAW BY INSUFFICIENT MATERIAL ##################################

# returns 1 in v0 if the position is a draw by insufficient material.
.macro	draw_insufficient(%p)

# First, make sure there are no pawns, queens, or rooks on the board.
add	$t0, $zero, %p
li	$t1, 0 # Loop counter
li	$t6, 0 # Number of white knights.
li	$t7, 0 # Number of white bishops.
li	$t8, 0 # Number of black knights.
li	$t9, 0 # Number of black bishops.
loopInsufficient:
lb	$t2, ($t0)
beq	$t2, -5, sufficientMaterial
beq	$t2, -4, sufficientMaterial
beq	$t2, -3, addBlackBishop
beq	$t2, -2, addBlackKnight
beq	$t2, -1, sufficientMaterial
beq	$t2, 5, sufficientMaterial
beq	$t2, 4, sufficientMaterial
beq	$t2, 3, addWhiteBishop
beq	$t2, 2, addWhiteKnight
beq	$t2, 1, sufficientMaterial
afterAdd:
addi	$t0, $t0, 1
addi	$t1, $t1, 1
bge	$t1, 64, endLoopInsufficient
j	loopInsufficient
endLoopInsufficient:
add	$t3, $t6, $t7
add	$t4, $t8, $t9
bge	$t3, 3, sufficientMaterial
bge	$t4, 3, sufficientMaterial
blt	$t3, 2, checkInsufficient
afterCheckInsufficient:
beq	$t6, 2, checkBlackMaterial
beq	$t8, 2, checkWhiteMaterial
j	sufficientMaterial

addBlackBishop:
addi	$t9, $t9, 1
j	afterAdd	

addBlackKnight:
addi	$t8, $t8, 1
j	afterAdd

addWhiteBishop:
addi	$t7, $t7, 1
j	afterAdd

addWhiteKnight:
addi	$t6, $t6, 1
j	afterAdd

checkInsufficient:
blt	$t4, 2, insufficientMaterial
j	afterCheckInsufficient

checkBlackMaterial:
beqz	$t4, insufficientMaterial
j	sufficientMaterial

checkWhiteMaterial:
beqz	$t3, insufficientMaterial

sufficientMaterial:
li	$v0, 0
j	endInsufficient

insufficientMaterial:
li	$v0, 1

endInsufficient:

.end_macro

############################## WHITE DRAW ##################################

# returns 1 in v0 if it is a draw at the beginning of white's turn.
.macro	white_draw(%p, %lp)
white_in_stalemate(%p, %lp)
subi	$sp, $sp, 12
sw	$v0, ($sp)
draw_by_repetition
sw	$v0, 4($sp)
fifty_move_rule
sw	$v0, 8($sp)
draw_insufficient(%p)
move	$t0, $v0
lw	$t1, ($sp)
lw	$t2, 4($sp)
lw	$t3, 8($sp)
addi	$sp, $sp, 12
or	$t0, $t0, $t1
or	$t0, $t0, $t2
or	$t0, $t0, $t3 # t0 will now contain a 1 if there is a draw.
move	$v0, $t0

.end_macro

############################## BLACK DRAW ##################################

# returns 1 in v0 if it is a draw at the beginning of black's turn.
.macro	black_draw(%p, %lp)
black_in_stalemate(%p, %lp)
subi	$sp, $sp, 12
sw	$v0, ($sp)
draw_by_repetition
sw	$v0, 4($sp)
fifty_move_rule
sw	$v0, 8($sp)
draw_insufficient(%p)
move	$t0, $v0
lw	$t1, ($sp)
lw	$t2, 4($sp)
lw	$t3, 8($sp)
addi	$sp, $sp, 12
or	$t0, $t0, $t1
or	$t0, $t0, $t2
or	$t0, $t0, $t3 # t0 will now contain a 1 if there is a draw.
move	$v0, $t0

.end_macro

############################## WHITE RANDOM MOVE ##################################

# Plays a random move for white. Uses the cache. Returns 0 if the game is not over, and 1 if it is.
.macro	white_random_move
subi	$a2, $s7, 64 # One move ago
subi	$a3, $s7, 128 # Two moves ago
white_in_checkmate($a2, $a3)
beq	$v0, 1, gameOverWhite
white_draw($a2, $a3)
beq	$v0, 1, gameOverWhite
count_moves_white($a2, $a3)
move	$a0, $zero
move	$a1, $v0
li	$v0, 42
syscall # Puts a random number into a0.
addi	$a0, $a0, 1
gen_pos_white($a2, $a3, $a0)
li	$v0, 0
j	endRandomWhite

gameOverWhite:
li	$v0, 1

endRandomWhite:

.end_macro

############################## BLACK RANDOM MOVE ##################################

# Plays a random move for black. Uses the cache. Returns 0 if the game is not over, and 1 if it is.
.macro	black_random_move
subi	$a2, $s7, 64 # One move ago
subi	$a3, $s7, 128 # Two moves ago
black_in_checkmate($a2, $a3)
beq	$v0, 1, gameOverBlack
black_draw($a2, $a3)
beq	$v0, 1, gameOverBlack
count_moves_black($a2, $a3)
move	$a0, $zero
move	$a1, $v0
li	$v0, 42
syscall # Puts a random number into a0.
addi	$a0, $a0, 1
gen_pos_black($a2, $a3, $a0)
li	$v0, 0
j	endRandomBlack

gameOverBlack:
li	$v0, 1

endRandomBlack:

.end_macro

############################## GENERATE WHITE POSITION ##################################

# p is the base address of a position, while n is the index of the position to be generated.
# returns 0 in $v0 if the position wasn't be generated.
# Puts the generated position on the cache, using the cache pointer. Does this through the move piece macro.
# v1 will be the number of positions that were searched.
.macro gen_pos_white(%p, %lp, %n)

add	$t0, $zero, %p
add	$t6, $zero, %n
subi	$sp, $sp, 4
sw	$t6, ($sp)
li	$t1, 0 # Coordinates of the piece can be extrapolated from this number.
loopGenPosWhite:
subi 	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
extrapolate_coords($t1)
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
move	$t3, $v0
move	$t4, $v1
lb	$t2, ($t0)
blez	$t2, nextPieceWhite
beq	$t2, 1, findWhiteMovesPawn
beq	$t2, 2, findWhiteMovesKnight
beq	$t2, 3, findWhiteMovesBishop
beq	$t2, 4, findWhiteMovesRook
beq	$t2, 5, findWhiteMovesBishop
beq	$t2, 6, findWhiteMovesKing
j	nextPieceWhite

#------------------------------------------------------------------------------
# IF PAWN # Check 2 ahead, then 1 ahead, then diag captures, then en passant
#------------------------------------------------------------------------------

findWhiteMovesPawn:

# CHECK TWO AHEAD
checkAheadTwoWhitePawn:
bne	$t4, 6, checkAheadOneWhitePawn
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, 5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, $zero, checkLeftDiagWhitePawn
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, 4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, $zero, checkAheadOneWhitePawn # Now we check if we are moving into check.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t3, 4, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popTwoWhitePawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkAheadOneWhitePawn
popTwoWhitePawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkAheadOneWhitePawn

# CHECK ONE AHEAD
checkAheadOneWhitePawn: # Don't forget about promotions!
subi	$t7, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, $zero, checkLeftDiagWhitePawn
bne	$t4, 1, regWhitePawnMove

# Promotion pawn move
knightPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t3, $zero, 2) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popOneWhitePawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

bishopPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t3, $zero, 3) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

rookPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t3, $zero, 4) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

queenPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t3, $zero, 5) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkLeftDiagWhitePawn

# Regular pawn move

regWhitePawnMove:
subi	$t7, $t4, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popOneWhitePawn
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkLeftDiagWhitePawn

popOneWhitePawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# CHECK LEFT DIAG
checkLeftDiagWhitePawn: # Don't forget promotions!
beqz	$t3, checkRightDiagWhitePawn
subi	$t5, $t3, 1
subi	$t7, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgez	$v0, checkRightDiagWhitePawn
bne	$t4, 1, regWhiteLeftPawnMove

# Promotion pawn move: left diagonal capture

whiteKnightPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 2) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popLeftWhitePawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

whiteBishopPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 3) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

whiteRookPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 4) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

whiteQueenPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 5) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkRightDiagWhitePawn

regWhiteLeftPawnMove:

subi	$t5, $t3, 1
subi	$t7, $t4, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popLeftWhitePawn
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkRightDiagWhitePawn

popLeftWhitePawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4


# CHECK RIGHT DIAG

checkRightDiagWhitePawn: # Don't forget promotions!
beq	$t3, 7, checkEnPassantWhite
addi	$t5, $t3, 1
subi	$t7, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgez	$v0, checkEnPassantWhite
bne	$t4, 1, regWhiteRightPawnMove

# Promotion pawn move: right diagonal capture

whiteKnightPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 2) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popRightWhitePawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

whiteBishopPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 3) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

whiteRookPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 4) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

whiteQueenPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t5, $zero, 5) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkEnPassantWhite

regWhiteRightPawnMove:
addi	$t5, $t3, 1
subi	$t7, $t4, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popRightWhitePawn
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkEnPassantWhite

popRightWhitePawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# CHECK EN PASSANT

checkEnPassantWhite:
bne	$t4, 3, nextPieceWhite
# check left, and then right.
leftEPWhite:
beqz	$t3, rightEPWhite
subi	$t5, $t3, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 3)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, -1, rightEPWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 1)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, rightEPWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 3)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, rightEPWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 1)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, -1, rightEPWhite # If we are still here then we may qualify for an en passant move.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 3, $t5, 2, 1) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popEPLeftWhite # Otherwise, en passant is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

rightEPWhite:
beq	$t3, 7, nextPieceWhite
addi	$t5, $t3, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 3)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, -1, nextPieceWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 1)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, nextPieceWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 3)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, nextPieceWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 1)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, -1, nextPieceWhite # If we are still here then we may qualify for an en passant move.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 3, $t5, 2, 1) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popEPRightWhite # Otherwise, en passant is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceWhite

popEPLeftWhite:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	rightEPWhite

popEPRightWhite:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceWhite

j	nextPieceWhite

#------------------------------------------------------------------------------
# IF KNIGHT 
#------------------------------------------------------------------------------

findWhiteMovesKnight:

firstWhiteKnightMove:
subi	$t5, $t3, 2
bltz	$t5, thirdWhiteKnightMove
subi	$t7, $t4, 1
bltz	$t7, secondWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, secondWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popFirstWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popFirstWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

secondWhiteKnightMove:
subi	$t5, $t3, 2
bltz	$t5, thirdWhiteKnightMove
addi	$t7, $t4, 1
bgt	$t7, 7, thirdWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, thirdWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popSecondWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popSecondWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

thirdWhiteKnightMove:
subi	$t5, $t3, 1
bltz	$t5, fifthWhiteKnightMove
subi	$t7, $t4, 2
bltz	$t7, fourthWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, fourthWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popThirdWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popThirdWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

fourthWhiteKnightMove:
subi	$t5, $t3, 1
bltz	$t5, fifthWhiteKnightMove
addi	$t7, $t4, 2
bgt	$t7, 7, fifthWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, fifthWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popFourthWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popFourthWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

fifthWhiteKnightMove:
addi	$t5, $t3, 1
bgt	$t5, 7, nextPieceWhite
subi	$t7, $t4, 2
bltz	$t7, sixthWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, sixthWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popFifthWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popFifthWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

sixthWhiteKnightMove:
addi	$t5, $t3, 1
bgt	$t5, 7, nextPieceWhite
addi	$t7, $t4, 2
bgt	$t7, 7, seventhWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, seventhWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popSixthWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popSixthWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

seventhWhiteKnightMove:
addi	$t5, $t3, 2
bgt	$t5, 7, nextPieceWhite
subi	$t7, $t4, 1
bltz	$t7, eighthWhiteKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, eighthWhiteKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popSeventhWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popSeventhWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

eighthWhiteKnightMove:
addi	$t5, $t3, 2
bgt	$t5, 7, nextPieceWhite
addi	$t7, $t4, 1
bgt	$t7, 7, nextPieceWhite # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, nextPieceWhite
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popEighthWhiteKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popEighthWhiteKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceWhite

#------------------------------------------------------------------------------
# IF BISHOP
#------------------------------------------------------------------------------

findWhiteMovesBishop:

# Look northeast
whiteBishopMoveNorthEast:
addi	$t5, $t3, 1
subi	$t7, $t4, 1
# Add to coords at the end.
loopWhiteBishopNE:
bgt	$t5, 7, whiteBishopMoveSouthEast
bltz	$t7, whiteBishopMoveSouthEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteBishopMoveSouthEast
bltz	$v0, finalWhiteBishopMoveNorthEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopNE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopNE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t5, $t5, 1
subi	$t7, $t7, 1
j	loopWhiteBishopNE
##########
finalWhiteBishopMoveNorthEast:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopNEFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopNEFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southeast
whiteBishopMoveSouthEast:
addi	$t5, $t3, 1
addi	$t7, $t4, 1
# Add to coords at the end.
loopWhiteBishopSE:
bgt	$t5, 7, whiteBishopMoveSouthWest
bgt	$t7, 7, whiteBishopMoveSouthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteBishopMoveSouthWest
bltz	$v0, finalWhiteBishopMoveSouthEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopSE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopSE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t5, $t5, 1
addi	$t7, $t7, 1
j	loopWhiteBishopSE
##########
finalWhiteBishopMoveSouthEast:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopSEFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopSEFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southwest
whiteBishopMoveSouthWest:
subi	$t5, $t3, 1
addi	$t7, $t4, 1
# Add to coords at the end.
loopWhiteBishopSW:
bltz	$t5, whiteBishopMoveNorthWest
bgt	$t7, 7, whiteBishopMoveNorthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteBishopMoveNorthWest
bltz	$v0, finalWhiteBishopMoveSouthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopSW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopSW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t5, $t5, 1
addi	$t7, $t7, 1
j	loopWhiteBishopSW
##########
finalWhiteBishopMoveSouthWest:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopSWFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopSWFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look northwest
whiteBishopMoveNorthWest:
subi	$t5, $t3, 1
subi	$t7, $t4, 1
# Add to coords at the end.
loopWhiteBishopNW:
bltz	$t5, checkQueenWhite
bltz	$t7, checkQueenWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, checkQueenWhite
bltz	$v0, finalWhiteBishopMoveNorthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopNW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopNW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t5, $t5, 1
subi	$t7, $t7, 1
j	loopWhiteBishopNW
##########
finalWhiteBishopMoveNorthWest:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteBishopNWFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteBishopNWFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Check if queen
checkQueenWhite:
beq	$t2, 3, nextPieceWhite

#------------------------------------------------------------------------------
# IF ROOK
#------------------------------------------------------------------------------

findWhiteMovesRook:

# Look north
whiteRookMoveNorth:
subi	$t7, $t4, 1
# Add to coords at the end.
loopWhiteRookN:
bltz	$t7, whiteRookMoveEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteRookMoveEast
bltz	$v0, finalWhiteRookMoveNorth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookN
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookN:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t7, $t7, 1
j	loopWhiteRookN
##########
finalWhiteRookMoveNorth:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookNFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookNFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look east
whiteRookMoveEast:
addi	$t5, $t3, 1
# Add to coords at the end.
loopWhiteRookE:
bgt	$t5, 7, whiteRookMoveSouth
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteRookMoveSouth
bltz	$v0, finalWhiteRookMoveEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t5, $t5, 1
j	loopWhiteRookE
##########
finalWhiteRookMoveEast:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookEFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookEFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look south
whiteRookMoveSouth:
addi	$t7, $t4, 1
# Add to coords at the end.
loopWhiteRookS:
bgt	$t7, 7, whiteRookMoveWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteRookMoveWest
bltz	$v0, finalWhiteRookMoveSouth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookS
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookS:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t7, $t7, 1
j	loopWhiteRookS
##########
finalWhiteRookMoveSouth:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookSFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookSFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look west
whiteRookMoveWest:
subi	$t5, $t3, 1
# Add to coords at the end.
loopWhiteRookW:
bltz	$t5, nextPieceWhite
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, nextPieceWhite
bltz	$v0, finalWhiteRookMoveWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t5, $t5, 1
j	loopWhiteRookW
##########
finalWhiteRookMoveWest:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteRookWFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteRookWFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceWhite

#------------------------------------------------------------------------------
# IF KING
#------------------------------------------------------------------------------

findWhiteMovesKing:

# Look northeast
whiteKingMoveNorthEast:
addi	$t5, $t3, 1
subi	$t7, $t4, 1
bgt	$t5, 7, whiteKingMoveSouthWest
bltz	$t7, whiteKingMoveSouthEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveSouthEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingNE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingNE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southeast
whiteKingMoveSouthEast:
addi	$t5, $t3, 1
addi	$t7, $t4, 1
bgt	$t5, 7, whiteKingMoveSouthWest
bgt	$t7, 7, whiteKingMoveNorthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveSouthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingSE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingSE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southwest
whiteKingMoveSouthWest:
subi	$t5, $t3, 1
addi	$t7, $t4, 1
bltz	$t5, whiteKingMoveNorth
bgt	$t7, 7, whiteKingMoveNorthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveNorthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingSW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingSW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look northwest
whiteKingMoveNorthWest:
subi	$t5, $t3, 1
subi	$t7, $t4, 1
bltz	$t5, whiteKingMoveNorth
bltz	$t7, whiteKingMoveEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveNorth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingNW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingNW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look north
whiteKingMoveNorth:
subi	$t7, $t4, 1
bltz	$t7, whiteKingMoveEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingN
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingN:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look east
whiteKingMoveEast:
addi	$t5, $t3, 1
bgt	$t5, 7, whiteKingMoveSouth
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveSouth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look south
whiteKingMoveSouth:
addi	$t7, $t4, 1
bgt	$t7, 7, whiteKingMoveWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteKingMoveWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingS
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingS:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look west
whiteKingMoveWest:
subi	$t5, $t3, 1
bltz	$t5, whiteCastle
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, whiteCastle
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Castling
whiteCastle:
# Make sure white is not in check.
subi	$t8, $s7, 64 # t8 now has the base address of the current position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is in check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, nextPieceWhite
# Go through cache, make sure king has never moved.
sll	$t9, $s5, 6
sub	$t8, $s7, $t9 # t8 has the address of the very beginning of the cache.
li	$t7, 0 # Loop counter
whiteCastleLoopCache:
lb	$t9, 60($t8)
bne	$t9, 6, nextPieceWhite
addi	$t7, $t7, 1
addi	$t8, $t8, 64 # To the next cache item.
bge	$t7, $s5, whiteKingsideCastle
j	whiteCastleLoopCache

# Kingside Castle
whiteKingsideCastle:
add	$t9, $zero, %p
lb	$t8, 61($t9)
bnez	$t8, whiteQueensideCastle
lb	$t8, 62($t9)
bnez	$t8, whiteQueensideCastle
# Go through cache, make sure rook has never moved.
sll	$t9, $s5, 6
sub	$t8, $s7, $t9 # t8 has the address of the very beginning of the cache.
li	$t7, 0 # Loop counter
whiteCastleKLoopCache:
lb	$t9, 63($t8)
bne	$t9, 4, whiteQueensideCastle
addi	$t7, $t7, 1
addi	$t8, $t8, 64 # To the next cache item.
bge	$t7, $s5, continueWhiteKingside
j	whiteCastleKLoopCache
continueWhiteKingside:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 7, 5, 7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingsideC
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4 # Now we castle.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 7, 6, 7, 6) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteKingsideC
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteKingsideC:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Queenside Castle
whiteQueensideCastle:
add	$t9, $zero, %p
lb	$t8, 57($t9)
bnez	$t8, nextPieceWhite
lb	$t8, 58($t9)
bnez	$t8, nextPieceWhite
lb	$t8, 58($t9)
bnez	$t8, nextPieceWhite
# Go through cache, make sure rook has never moved.
sll	$t9, $s5, 6
sub	$t8, $s7, $t9 # t8 has the address of the very beginning of the cache.
li	$t7, 0 # Loop counter
whiteCastleQLoopCache:
lb	$t9, 56($t8)
bne	$t9, 4, nextPieceWhite
addi	$t7, $t7, 1
addi	$t8, $t8, 64 # To the next cache item.
bge	$t7, $s5, continueWhiteQueenside
j	whiteCastleQLoopCache
continueWhiteQueenside:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 7, 3, 7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteQueensideC
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4 # Now we castle.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 7, 2, 7, 7) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
white_in_check($t8) # v0 will now contain 1 if white is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popWhiteQueensideC
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosWhite # Here, we have found the correct move for the given number. Leave it on the stack.
popWhiteQueensideC:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

#------------------------------------------------------------------------------
# NEXT PIECE
#------------------------------------------------------------------------------

nextPieceWhite:
addi	$t1, $t1, 1
addi	$t0, $t0, 1
bge	$t1, 64, endLoopGenPosWhite2
j	loopGenPosWhite

# If the move find was unsuccessful
endLoopGenPosWhite2:
li	$v0, 0
lw	$v1, ($sp)
sub	$v1, $v1, $t6
j	endGenWhite
# If the move find was successful
endLoopGenPosWhite:
li	$v0, 1
lw	$v1, ($sp)
endGenWhite:
addi	$sp, $sp, 4

.end_macro

############################## GENERATE BLACK POSITION ##################################

# p is the base address of a position, while n is the index of the position to be generated.
# returns 0 in $v0 if the position wasn't be generated.
# Puts the generated position on the cache, using the cache pointer. Does this through the move piece macro.
.macro gen_pos_black(%p, %lp, %n)

add	$t0, $zero, %p
add	$t6, $zero, %n
subi	$sp, $sp, 4
sw	$t6, ($sp)
li	$t1, 0 # Coordinates of the piece can be extrapolated from this number.
loopGenPosBlack:
subi 	$sp, $sp, 8
sw	$t0, ($sp)
sw	$t1, 4($sp)
extrapolate_coords($t1)
lw	$t0, ($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
move	$t3, $v0
move	$t4, $v1
lb	$t2, ($t0)
bgez	$t2, nextPieceBlack
beq	$t2, -1, findBlackMovesPawn
beq	$t2, -2, findBlackMovesKnight
beq	$t2, -3, findBlackMovesBishop
beq	$t2, -4, findBlackMovesRook
beq	$t2, -5, findBlackMovesBishop
beq	$t2, -6, findBlackMovesKing
j	nextPieceBlack

#------------------------------------------------------------------------------
# IF PAWN # Check 2 ahead, then 1 ahead, then diag captures, then en passant
#------------------------------------------------------------------------------

findBlackMovesPawn:

# CHECK TWO AHEAD
checkAheadTwoBlackPawn:
bne	$t4, 1, checkAheadOneBlackPawn
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, 2)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, $zero, checkLeftDiagBlackPawn
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, 3)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, $zero, checkAheadOneBlackPawn # Now we check if we are moving into check.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 1, $t3, 3, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popTwoBlackPawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkAheadOneBlackPawn
popTwoBlackPawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkAheadOneBlackPawn

# CHECK ONE AHEAD
checkAheadOneBlackPawn: # Don't forget about promotions!
addi	$t7, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, $zero, checkLeftDiagBlackPawn
bne	$t4, 6, regBlackPawnMove

# Promotion pawn move
knightPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t3, 7, -2) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popOneBlackPawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

bishopPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t3, 7, -3) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

rookPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t3, 7, -4) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

queenPromotion:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t3, 7, -5) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkLeftDiagBlackPawn

# Regular pawn move

regBlackPawnMove:
addi	$t7, $t4, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popOneBlackPawn
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkLeftDiagBlackPawn

popOneBlackPawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# CHECK LEFT DIAG
checkLeftDiagBlackPawn: # Don't forget promotions!
beqz	$t3, checkRightDiagBlackPawn
subi	$t5, $t3, 1
addi	$t7, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
blez	$v0, checkRightDiagBlackPawn
bne	$t4, 6, regBlackLeftPawnMove

# Promotion pawn move: left diagonal capture

blackKnightPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -2) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popLeftBlackPawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

blackBishopPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -3) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

blackRookPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -4) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

blackQueenPromotionL:
subi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -5) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkRightDiagBlackPawn

regBlackLeftPawnMove:

subi	$t5, $t3, 1
addi	$t7, $t4, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popLeftBlackPawn
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkRightDiagBlackPawn

popLeftBlackPawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4


# CHECK RIGHT DIAG

checkRightDiagBlackPawn: # Don't forget promotions!
beq	$t3, 7, checkEnPassantBlack
addi	$t5, $t3, 1
addi	$t7, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
blez	$v0, checkEnPassantBlack
bne	$t4, 6, regBlackRightPawnMove

# Promotion pawn move: right diagonal capture

blackKnightPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -2) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popRightBlackPawn # If we are still here, then the move is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

blackBishopPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -3) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

blackRookPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -4) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

blackQueenPromotionR:
addi	$t5, $t3, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 6, $t5, 7, -5) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkEnPassantBlack

regBlackRightPawnMove:
addi	$t5, $t3, 1
addi	$t7, $t4, 1
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, $zero) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popRightBlackPawn
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	checkEnPassantBlack

popRightBlackPawn:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# CHECK EN PASSANT

checkEnPassantBlack:
bne	$t4, 4, nextPieceBlack
# check left, and then right.
leftEPBlack:
beqz	$t3, rightEPBlack
subi	$t5, $t3, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, 1, rightEPBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 6)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, rightEPBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, rightEPBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 6)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, 1, rightEPBlack # If we are still here then we may qualify for an en passant move.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 4, $t5, 5, -1) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popEPLeftBlack # Otherwise, en passant is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

rightEPBlack:
beq	$t3, 7, nextPieceBlack
addi	$t5, $t3, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, 1, nextPieceBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, 6)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, nextPieceBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bnez	$v0, nextPieceBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%lp, $t5, 6)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bne	$v0, 1, nextPieceBlack # If we are still here then we may qualify for an en passant move.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, 4, $t5, 5, -1) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popEPRightBlack # Otherwise, en passant is valid.
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
subi	$sp, $sp, 4 # Otherwise, we pop the position, and go to the next move.
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceBlack

popEPLeftBlack:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	rightEPBlack

popEPRightBlack:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceBlack

j	nextPieceBlack

#------------------------------------------------------------------------------
# IF KNIGHT 
#------------------------------------------------------------------------------

findBlackMovesKnight:

firstBlackKnightMove:
subi	$t5, $t3, 2
bltz	$t5, thirdBlackKnightMove
subi	$t7, $t4, 1
bltz	$t7, secondBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, secondBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popFirstBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popFirstBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

secondBlackKnightMove:
subi	$t5, $t3, 2
bltz	$t5, thirdBlackKnightMove
addi	$t7, $t4, 1
bgt	$t7, 7, thirdBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, thirdBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popSecondBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popSecondBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

thirdBlackKnightMove:
subi	$t5, $t3, 1
bltz	$t5, fifthBlackKnightMove
subi	$t7, $t4, 2
bltz	$t7, fourthBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, fourthBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popThirdBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popThirdBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

fourthBlackKnightMove:
subi	$t5, $t3, 1
bltz	$t5, fifthBlackKnightMove
addi	$t7, $t4, 2
bgt	$t7, 7, fifthBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, fifthBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popFourthBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popFourthBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

fifthBlackKnightMove:
addi	$t5, $t3, 1
bgt	$t5, 7, nextPieceBlack
subi	$t7, $t4, 2
bltz	$t7, sixthBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, sixthBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popFifthBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popFifthBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

sixthBlackKnightMove:
addi	$t5, $t3, 1
bgt	$t5, 7, nextPieceBlack
addi	$t7, $t4, 2
bgt	$t7, 7, seventhBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, seventhBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popSixthBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popSixthBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

seventhBlackKnightMove:
addi	$t5, $t3, 2
bgt	$t5, 7, nextPieceBlack
subi	$t7, $t4, 1
bltz	$t7, eighthBlackKnightMove # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, eighthBlackKnightMove
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popSeventhBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popSeventhBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

eighthBlackKnightMove:
addi	$t5, $t3, 2
bgt	$t5, 7, nextPieceBlack
addi	$t7, $t4, 1
bgt	$t7, 7, nextPieceBlack # If we are here, the target square is on the board
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, nextPieceBlack
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popEighthBlackKnight
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popEighthBlackKnight:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceBlack

#------------------------------------------------------------------------------
# IF BISHOP
#------------------------------------------------------------------------------

findBlackMovesBishop:

# Look northeast
blackBishopMoveNorthEast:
addi	$t5, $t3, 1
subi	$t7, $t4, 1
# Add to coords at the end.
loopBlackBishopNE:
bgt	$t5, 7, blackBishopMoveSouthEast
bltz	$t7, blackBishopMoveSouthEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackBishopMoveSouthEast
bgtz	$v0, finalBlackBishopMoveNorthEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopNE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopNE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t5, $t5, 1
subi	$t7, $t7, 1
j	loopBlackBishopNE
##########
finalBlackBishopMoveNorthEast:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopNEFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopNEFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southeast
blackBishopMoveSouthEast:
addi	$t5, $t3, 1
addi	$t7, $t4, 1
# Add to coords at the end.
loopBlackBishopSE:
bgt	$t5, 7, blackBishopMoveSouthWest
bgt	$t7, 7, blackBishopMoveSouthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackBishopMoveSouthWest
bgtz	$v0, finalBlackBishopMoveSouthEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopSE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopSE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t5, $t5, 1
addi	$t7, $t7, 1
j	loopBlackBishopSE
##########
finalBlackBishopMoveSouthEast:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopSEFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopSEFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southwest
blackBishopMoveSouthWest:
subi	$t5, $t3, 1
addi	$t7, $t4, 1
# Add to coords at the end.
loopBlackBishopSW:
bltz	$t5, blackBishopMoveNorthWest
bgt	$t7, 7, blackBishopMoveNorthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackBishopMoveNorthWest
bgtz	$v0, finalBlackBishopMoveSouthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopSW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopSW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t5, $t5, 1
addi	$t7, $t7, 1
j	loopBlackBishopSW
##########
finalBlackBishopMoveSouthWest:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopSWFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopSWFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look northwest
blackBishopMoveNorthWest:
subi	$t5, $t3, 1
subi	$t7, $t4, 1
# Add to coords at the end.
loopBlackBishopNW:
bltz	$t5, checkQueenBlack
bltz	$t7, checkQueenBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, checkQueenBlack
bgtz	$v0, finalBlackBishopMoveNorthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopNW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopNW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t5, $t5, 1
subi	$t7, $t7, 1
j	loopBlackBishopNW
##########
finalBlackBishopMoveNorthWest:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackBishopNWFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackBishopNWFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

checkQueenBlack:
beq	$t2, -3, nextPieceBlack

#------------------------------------------------------------------------------
# IF ROOK
#------------------------------------------------------------------------------

findBlackMovesRook:

# Look north
blackRookMoveNorth:
subi	$t7, $t4, 1
# Add to coords at the end.
loopBlackRookN:
bltz	$t7, blackRookMoveEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackRookMoveEast
bgtz	$v0, finalBlackRookMoveNorth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookN
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookN:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t7, $t7, 1
j	loopBlackRookN
##########
finalBlackRookMoveNorth:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookNFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookNFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look east
blackRookMoveEast:
addi	$t5, $t3, 1
# Add to coords at the end.
loopBlackRookE:
bgt	$t5, 7, blackRookMoveSouth
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackRookMoveSouth
bgtz	$v0, finalBlackRookMoveEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t5, $t5, 1
j	loopBlackRookE
##########
finalBlackRookMoveEast:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookEFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookEFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look south
blackRookMoveSouth:
addi	$t7, $t4, 1
# Add to coords at the end.
loopBlackRookS:
bgt	$t7, 7, blackRookMoveWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackRookMoveWest
bgtz	$v0, finalBlackRookMoveSouth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookS
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookS:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
addi	$t7, $t7, 1
j	loopBlackRookS
##########
finalBlackRookMoveSouth:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookSFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookSFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look west
blackRookMoveWest:
subi	$t5, $t3, 1
# Add to coords at the end.
loopBlackRookW:
bltz	$t5, nextPieceBlack
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, nextPieceBlack
bgtz	$v0, finalBlackRookMoveWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
subi	$t5, $t5, 1
j	loopBlackRookW
##########
finalBlackRookMoveWest:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackRookWFinal
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackRookWFinal:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4
j	nextPieceBlack

#------------------------------------------------------------------------------
# IF KING
#------------------------------------------------------------------------------

findBlackMovesKing:

# Look northeast
blackKingMoveNorthEast:
addi	$t5, $t3, 1
subi	$t7, $t4, 1
bgt	$t5, 7, blackKingMoveSouthWest
bltz	$t7, blackKingMoveSouthEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveSouthEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingNE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingNE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southeast
blackKingMoveSouthEast:
addi	$t5, $t3, 1
addi	$t7, $t4, 1
bgt	$t5, 7, blackKingMoveSouthWest
bgt	$t7, 7, blackKingMoveNorthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveSouthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingSE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingSE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look southwest
blackKingMoveSouthWest:
subi	$t5, $t3, 1
addi	$t7, $t4, 1
bltz	$t5, blackKingMoveNorth
bgt	$t7, 7, blackKingMoveNorthWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveNorthWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingSW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingSW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look northwest
blackKingMoveNorthWest:
subi	$t5, $t3, 1
subi	$t7, $t4, 1
bltz	$t5, blackKingMoveNorth
bltz	$t7, blackKingMoveEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveNorth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingNW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingNW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look north
blackKingMoveNorth:
subi	$t7, $t4, 1
bltz	$t7, blackKingMoveEast
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveEast
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingN
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingN:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look east
blackKingMoveEast:
addi	$t5, $t3, 1
bgt	$t5, 7, blackKingMoveSouth
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveSouth
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingE
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingE:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look south
blackKingMoveSouth:
addi	$t7, $t4, 1
bgt	$t7, 7, blackKingMoveWest
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t3, $t7)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackKingMoveWest
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t3, $t7, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingS
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingS:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Look west
blackKingMoveWest:
subi	$t5, $t3, 1
bltz	$t5, blackCastle
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square(%p, $t5, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, blackCastle
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, $t3, $t4, $t5, $t4, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingW
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingW:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Castling
blackCastle:
# Make sure black is not in check.
subi	$t8, $s7, 64 # t8 now has the base address of the current position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, nextPieceBlack
# Go through cache, make sure king has never moved.
sll	$t9, $s5, 6
sub	$t8, $s7, $t9 # t8 has the address of the very beginning of the cache.
li	$t7, 0 # Loop counter
blackCastleLoopCache:
lb	$t9, 4($t8)
bne	$t9, -6, nextPieceBlack
addi	$t7, $t7, 1
addi	$t8, $t8, 64 # To the next cache item.
bge	$t7, $s5, blackKingsideCastle
j	blackCastleLoopCache

# Kingside Castle
blackKingsideCastle:
add	$t9, $zero, %p
lb	$t8, 5($t9)
bnez	$t8, blackQueensideCastle
lb	$t8, 6($t9)
bnez	$t8, blackQueensideCastle
# Go through cache, make sure rook has never moved.
sll	$t9, $s5, 6
sub	$t8, $s7, $t9 # t8 has the address of the very beginning of the cache.
li	$t7, 0 # Loop counter
blackCastleKLoopCache:
lb	$t9, 7($t8)
bne	$t9, -4, blackQueensideCastle
addi	$t7, $t7, 1
addi	$t8, $t8, 64 # To the next cache item.
bge	$t7, $s5, continueBlackKingside
j	blackCastleKLoopCache
continueBlackKingside:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 0, 5, 0, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingsideC
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4 # Now we castle.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 0, 6, 0, -6) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackKingsideC
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackKingsideC:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

# Queenside Castle
blackQueensideCastle:
add	$t9, $zero, %p
lb	$t8, 1($t9)
bnez	$t8, nextPieceBlack
lb	$t8, 2($t9)
bnez	$t8, nextPieceBlack
lb	$t8, 3($t9)
bnez	$t8, nextPieceBlack
# Go through cache, make sure rook has never moved.
sll	$t9, $s5, 6
sub	$t8, $s7, $t9 # t8 has the address of the very beginning of the cache.
li	$t7, 0 # Loop counter
blackCastleQLoopCache:
lb	$t9, ($t8)
bne	$t9, -4, nextPieceBlack
addi	$t7, $t7, 1
addi	$t8, $t8, 64 # To the next cache item.
bge	$t7, $s5, continueBlackQueenside
j	blackCastleQLoopCache
continueBlackQueenside:
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 0, 3, 0, 0) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackQueensideC
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4 # Now we castle.
subi	$sp, $sp, 16
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t9, 12($sp)
move_piece(%p, 4, 0, 2, 0, -7) # Now there is a new position on the cache that we can use.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t9, 12($sp)
addi	$sp, $sp, 16
subi	$t8, $s7, 64 # t8 now has the base address of this new position.
subi	$sp, $sp, 24
sw	$t0, ($sp)
sw	$t1, 4($sp)
sw	$t2, 8($sp)
sw	$t3, 12($sp)
sw	$t4, 16($sp)
sw	$t5, 20($sp)
black_in_check($t8) # v0 will now contain 1 if black is moving into check.
lw	$t0, ($sp)
lw	$t1, 4($sp)
lw	$t2, 8($sp)
lw	$t3, 12($sp)
lw	$t4, 16($sp)
lw	$t5, 20($sp)
addi	$sp, $sp, 24
beq	$v0, 1, popBlackQueensideC
subi	$t6, $t6, 1
beqz	$t6, endLoopGenPosBlack # Here, we have found the correct move for the given number. Leave it on the stack.
popBlackQueensideC:
subi	$sp, $sp, 4
sw	$t0, ($sp)
pop_position
lw	$t0, ($sp)
addi	$sp, $sp, 4

#------------------------------------------------------------------------------
# NEXT PIECE
#------------------------------------------------------------------------------

nextPieceBlack:
addi	$t1, $t1, 1
addi	$t0, $t0, 1
bge	$t1, 64, endLoopGenPosBlack2
j	loopGenPosBlack

# If the move find was unsuccessful
endLoopGenPosBlack2:
li	$v0, 0
lw	$v1, ($sp)
sub	$v1, $v1, $t6
j	endGenBlack
# If the move find was successful
endLoopGenPosBlack:
li	$v0, 1
lw	$v1, ($sp)
endGenBlack:
addi	$sp, $sp, 4

.end_macro

############################## CHECK SQUARE ##################################

# Returns the value of the piece in the square.
# p is the base address of a position, x is the x coordinate of the square to be checked, and y is the y coord of that square.
# Returned in $v0.
.macro check_square(%p, %x, %y)
add	$t6, $zero, %p
add	$t8, $zero, %x
add	$t9, $zero, %y
sll	$t9, $t9, 3
add	$t6, $t6, $t8
add	$t6, $t6, $t9
lb	$v0, ($t6) # This should now contain the value of the piece at the given square.

.end_macro

############################## EXTRAPOLATE COORDS ##################################

# Using a number for a square, returns the values for the x and y coordinates into $v0 and $v1 respectively.
# n is the number of the square.
.macro	extrapolate_coords(%n)

add	$t0, $zero, %n
li	$t1, 8
div	$t0, $t1
mfhi	$v0
mflo	$v1

.end_macro

############################## WHITE IN CHECK ##################################

# Returns 1 if the white king is in check, and 0 if he is not (into v0).
# p is the base address of the position.
.macro white_in_check(%p)

# Find the king

add	$t0, $zero, %p
li	$t1, 0
loopPosWhiteInCheck:
lb	$t2, ($t0)
beq	$t2, 6, whiteKingFound
addi	$t1, $t1, 1
addi	$t0, $t0, 1
j	loopPosWhiteInCheck
whiteKingFound:
extrapolate_coords($t1)
move	$t1, $v0 # Has the x coord of the white king
move	$t2, $v1 # Has the y coord of the white king
add	$t0, $zero, %p # Reloads the base address of the position into t0.
# Check north

li	$t3, 0 # Keeps track of how many iterations of the loop have already gone by
move	$t4, $t1
move	$t5, $t2
loopNorthWhiteCheck:
blez	$t5, endLoopNorthWhiteCheck
subi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopNorthWhiteCheck
beq	$v0, -6, firstIterWhiteNorth
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, whiteKingInCheck
beq	$v0, -3, endLoopNorthWhiteCheck
beq	$v0, -2, endLoopNorthWhiteCheck
beq	$v0, -1, endLoopNorthWhiteCheck
addi	$t3, $t3, 1
j	loopNorthWhiteCheck
firstIterWhiteNorth:
beqz	$t3, whiteKingInCheck
endLoopNorthWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check northeast

loopNorthEastWhiteCheck:
bge	$t4, 7, endLoopNorthEastWhiteCheck
blez	$t5, endLoopNorthEastWhiteCheck
addi	$t4, $t4, 1
subi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopNorthEastWhiteCheck
beq	$v0, -6, firstIterWhiteNorthEast
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, endLoopNorthEastWhiteCheck
beq	$v0, -3, whiteKingInCheck
beq	$v0, -2, endLoopNorthEastWhiteCheck
beq	$v0, -1, firstIterWhiteNorthEast
addi	$t3, $t3, 1
j	loopNorthEastWhiteCheck
firstIterWhiteNorthEast:
beqz	$t3, whiteKingInCheck
endLoopNorthEastWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check east

loopEastWhiteCheck:
bge	$t4, 7, endLoopEastWhiteCheck
addi	$t4, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopEastWhiteCheck
beq	$v0, -6, firstIterWhiteEast
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, whiteKingInCheck
beq	$v0, -3, endLoopEastWhiteCheck
beq	$v0, -2, endLoopEastWhiteCheck
beq	$v0, -1, endLoopEastWhiteCheck
addi	$t3, $t3, 1
j	loopEastWhiteCheck
firstIterWhiteEast:
beqz	$t3, whiteKingInCheck
endLoopEastWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check southeast

loopSouthEastWhiteCheck:
bge	$t4, 7, endLoopSouthEastWhiteCheck
bge	$t5, 7, endLoopSouthEastWhiteCheck
addi	$t4, $t4, 1
addi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopSouthEastWhiteCheck
beq	$v0, -6, firstIterWhiteSouthEast
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, endLoopSouthEastWhiteCheck
beq	$v0, -3, whiteKingInCheck
beq	$v0, -2, endLoopSouthEastWhiteCheck
beq	$v0, -1, endLoopSouthEastWhiteCheck
addi	$t3, $t3, 1
j	loopSouthEastWhiteCheck
firstIterWhiteSouthEast:
beqz	$t3, whiteKingInCheck
endLoopSouthEastWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2
# Check south

loopSouthWhiteCheck:
bge	$t5, 7, endLoopSouthWhiteCheck
addi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopSouthWhiteCheck
beq	$v0, -6, firstIterWhiteSouth
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, whiteKingInCheck
beq	$v0, -3, endLoopSouthWhiteCheck
beq	$v0, -2, endLoopSouthWhiteCheck
beq	$v0, -1, endLoopSouthWhiteCheck
addi	$t3, $t3, 1
j	loopSouthWhiteCheck
firstIterWhiteSouth:
beqz	$t3, whiteKingInCheck
endLoopSouthWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check southwest

loopSouthWestWhiteCheck:
blez	$t4, endLoopSouthWestWhiteCheck
bge	$t5, 7, endLoopSouthWestWhiteCheck
subi	$t4, $t4, 1
addi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopSouthWestWhiteCheck
beq	$v0, -6, firstIterWhiteSouthWest
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, endLoopSouthWestWhiteCheck
beq	$v0, -3, whiteKingInCheck
beq	$v0, -2, endLoopSouthWestWhiteCheck
beq	$v0, -1, endLoopSouthWestWhiteCheck
addi	$t3, $t3, 1
j	loopSouthWestWhiteCheck
firstIterWhiteSouthWest:
beqz	$t3, whiteKingInCheck
endLoopSouthWestWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check west
loopWestWhiteCheck:
blez	$t4, endLoopWestWhiteCheck
subi	$t4, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopWestWhiteCheck
beq	$v0, -6, firstIterWhiteWest
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, whiteKingInCheck
beq	$v0, -3, endLoopWestWhiteCheck
beq	$v0, -2, endLoopWestWhiteCheck
beq	$v0, -1, endLoopWestWhiteCheck
addi	$t3, $t3, 1
j	loopWestWhiteCheck
firstIterWhiteWest:
beqz	$t3, whiteKingInCheck
endLoopWestWhiteCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check northwest

loopNorthWestWhiteCheck:
blez	$t4, endLoopNorthWestWhiteCheck
blez	$t5, endLoopNorthWestWhiteCheck
subi	$t4, $t4, 1
subi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bgtz	$v0, endLoopNorthWestWhiteCheck
beq	$v0, -6, firstIterWhiteNorthWest
beq	$v0, -5, whiteKingInCheck
beq	$v0, -4, endLoopNorthWestWhiteCheck
beq	$v0, -3, whiteKingInCheck
beq	$v0, -2, endLoopNorthWestWhiteCheck
beq	$v0, -1, firstIterWhiteNorthWest
addi	$t3, $t3, 1
j	loopNorthWestWhiteCheck
firstIterWhiteNorthWest:
beqz	$t3, whiteKingInCheck
endLoopNorthWestWhiteCheck:

# Check knight moves

subi	$t3, $t1, 2
bltz	$t3, thirdWhiteKnightCheck
subi	$t4, $t2, 1
bltz	$t4, secondWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

secondWhiteKnightCheck:
subi	$t3, $t1, 2
bltz	$t3, thirdWhiteKnightCheck
addi	$t4, $t2, 1
bgt	$t4, 7, thirdWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

thirdWhiteKnightCheck:
subi	$t3, $t1, 1
bltz	$t3, fifthWhiteKnightCheck
subi	$t4, $t2, 2
bltz	$t4, fourthWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

fourthWhiteKnightCheck:
subi	$t3, $t1, 1
bltz	$t3, fifthWhiteKnightCheck
addi	$t4, $t2, 2
bgt	$t4, 7, fifthWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

fifthWhiteKnightCheck:
addi	$t3, $t1, 1
bgt	$t3, 7, endWhiteCheck
subi	$t4, $t2, 2
bltz	$t4, sixthWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

sixthWhiteKnightCheck:
addi	$t3, $t1, 1
bgt	$t3, 7, endWhiteCheck
addi	$t4, $t2, 2
bgt	$t4, 7, seventhWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

seventhWhiteKnightCheck:
addi	$t3, $t1, 2
bgt	$t3, 7, endWhiteCheck
subi	$t4, $t2, 1
bltz	$t4, eighthWhiteKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck

eighthWhiteKnightCheck:
addi	$t3, $t1, 2
bgt	$t3, 7, endWhiteCheck
addi	$t4, $t2, 1
bgt	$t4, 7, endWhiteCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, -2, whiteKingInCheck
j	endWhiteCheck

whiteKingInCheck:
li	$v0, 1
j	endWhiteCheck2
endWhiteCheck:
li	$v0, 0
endWhiteCheck2:

.end_macro

############################## BLACK IN CHECK ##################################

# Returns 1 if the black king is in check, and 0 if he is not (into v0).
# p is the base address of the position.

.macro black_in_check(%p)

# Find the king

add	$t0, $zero, %p
li	$t1, 0
loopPosBlackInCheck:
lb	$t2, ($t0)
beq	$t2, -6, blackKingFound
addi	$t1, $t1, 1
addi	$t0, $t0, 1
j	loopPosBlackInCheck
blackKingFound:
extrapolate_coords($t1)
move	$t1, $v0 # Has the x coord of the black king
move	$t2, $v1 # Has the y coord of the black king
add	$t0, $zero, %p # Reloads the base address of the position into t0.

# Check north

li	$t3, 0 # Keeps track of how many iterations of the loop have already gone by
move	$t4, $t1
move	$t5, $t2
loopNorthBlackCheck:
blez	$t5, endLoopNorthBlackCheck
subi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopNorthBlackCheck
beq	$v0, 6, firstIterBlackNorth
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, blackKingInCheck
beq	$v0, 3, endLoopNorthBlackCheck
beq	$v0, 2, endLoopNorthBlackCheck
beq	$v0, 1, endLoopNorthBlackCheck
addi	$t3, $t3, 1
j	loopNorthBlackCheck
firstIterBlackNorth:
beqz	$t3, blackKingInCheck
endLoopNorthBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check northeast

loopNorthEastBlackCheck:
bge	$t4, 7, endLoopNorthEastBlackCheck
blez	$t5, endLoopNorthEastBlackCheck
addi	$t4, $t4, 1
subi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopNorthEastBlackCheck
beq	$v0, 6, firstIterBlackNorthEast
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, endLoopNorthEastBlackCheck
beq	$v0, 3, blackKingInCheck
beq	$v0, 2, endLoopNorthEastBlackCheck
beq	$v0, 1, endLoopNorthEastBlackCheck
addi	$t3, $t3, 1
j	loopNorthEastBlackCheck
firstIterBlackNorthEast:
beqz	$t3, blackKingInCheck
endLoopNorthEastBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check east

loopEastBlackCheck:
bge	$t4, 7, endLoopEastBlackCheck
addi	$t4, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopEastBlackCheck
beq	$v0, 6, firstIterBlackEast
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, blackKingInCheck
beq	$v0, 3, endLoopEastBlackCheck
beq	$v0, 2, endLoopEastBlackCheck
beq	$v0, 1, endLoopEastBlackCheck
addi	$t3, $t3, 1
j	loopEastBlackCheck
firstIterBlackEast:
beqz	$t3, blackKingInCheck
endLoopEastBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check southeast

loopSouthEastBlackCheck:
bge	$t4, 7, endLoopSouthEastBlackCheck
bge	$t5, 7, endLoopSouthEastBlackCheck
addi	$t4, $t4, 1
addi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopSouthEastBlackCheck
beq	$v0, 6, firstIterBlackSouthEast
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, endLoopSouthEastBlackCheck
beq	$v0, 3, blackKingInCheck
beq	$v0, 2, endLoopSouthEastBlackCheck
beq	$v0, 1, firstIterBlackSouthEast
addi	$t3, $t3, 1
j	loopSouthEastBlackCheck
firstIterBlackSouthEast:
beqz	$t3, blackKingInCheck
endLoopSouthEastBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check south

loopSouthBlackCheck:
bge	$t5, 7, endLoopSouthBlackCheck
addi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopSouthBlackCheck
beq	$v0, 6, firstIterBlackSouth
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, blackKingInCheck
beq	$v0, 3, endLoopSouthBlackCheck
beq	$v0, 2, endLoopSouthBlackCheck
beq	$v0, 1, endLoopSouthBlackCheck
addi	$t3, $t3, 1
j	loopSouthBlackCheck
firstIterBlackSouth:
beqz	$t3, blackKingInCheck
endLoopSouthBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check southwest

loopSouthWestBlackCheck:
blez	$t4, endLoopSouthWestBlackCheck
bge	$t5, 7, endLoopSouthWestBlackCheck
subi	$t4, $t4, 1
addi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopSouthWestBlackCheck
beq	$v0, 6, firstIterBlackSouthWest
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, endLoopSouthWestBlackCheck
beq	$v0, 3, blackKingInCheck
beq	$v0, 2, endLoopSouthWestBlackCheck
beq	$v0, 1, firstIterBlackSouthWest
addi	$t3, $t3, 1
j	loopSouthWestBlackCheck
firstIterBlackSouthWest:
beqz	$t3, blackKingInCheck
endLoopSouthWestBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check west

loopWestBlackCheck:
blez	$t4, endLoopWestBlackCheck
subi	$t4, $t4, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopWestBlackCheck
beq	$v0, 6, firstIterBlackWest
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, blackKingInCheck
beq	$v0, 3, endLoopWestBlackCheck
beq	$v0, 2, endLoopWestBlackCheck
beq	$v0, 1, endLoopWestBlackCheck
addi	$t3, $t3, 1
j	loopWestBlackCheck
firstIterBlackWest:
beqz	$t3, blackKingInCheck
endLoopWestBlackCheck:
li	$t3, 0
move	$t4, $t1
move	$t5, $t2

# Check northwest

loopNorthWestBlackCheck:
blez	$t4, endLoopNorthWestBlackCheck
blez	$t5, endLoopNorthWestBlackCheck
subi	$t4, $t4, 1
subi	$t5, $t5, 1
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t4, $t5)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
bltz	$v0, endLoopNorthWestBlackCheck
beq	$v0, 6, firstIterBlackNorthWest
beq	$v0, 5, blackKingInCheck
beq	$v0, 4, endLoopNorthWestBlackCheck
beq	$v0, 3, blackKingInCheck
beq	$v0, 2, endLoopNorthWestBlackCheck
beq	$v0, 1, endLoopNorthWestBlackCheck
addi	$t3, $t3, 1
j	loopNorthWestBlackCheck
firstIterBlackNorthWest:
beqz	$t3, blackKingInCheck
endLoopNorthWestBlackCheck:

# Check knight moves

subi	$t3, $t1, 2
bltz	$t3, thirdBlackKnightCheck
subi	$t4, $t2, 1
bltz	$t4, secondBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

secondBlackKnightCheck:
subi	$t3, $t1, 2
bltz	$t3, thirdBlackKnightCheck
addi	$t4, $t2, 1
bgt	$t4, 7, thirdBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

thirdBlackKnightCheck:
subi	$t3, $t1, 1
bltz	$t3, fifthBlackKnightCheck
subi	$t4, $t2, 2
bltz	$t4, fourthBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

fourthBlackKnightCheck:
subi	$t3, $t1, 1
bltz	$t3, fifthBlackKnightCheck
addi	$t4, $t2, 2
bgt	$t4, 7, fifthBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

fifthBlackKnightCheck:
addi	$t3, $t1, 1
bgt	$t3, 7, endBlackCheck
subi	$t4, $t2, 2
bltz	$t4, sixthBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

sixthBlackKnightCheck:
addi	$t3, $t1, 1
bgt	$t3, 7, endBlackCheck
addi	$t4, $t2, 2
bgt	$t4, 7, seventhBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

seventhBlackKnightCheck:
addi	$t3, $t1, 2
bgt	$t3, 7, endBlackCheck
subi	$t4, $t2, 1
bltz	$t4, eighthBlackKnightCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck

eighthBlackKnightCheck:
addi	$t3, $t1, 2
bgt	$t3, 7, endBlackCheck
addi	$t4, $t2, 1
bgt	$t4, 7, endBlackCheck
subi	$sp, $sp, 12
sw	$t6, ($sp)
sw	$t8, 4($sp)
sw	$t9, 8($sp)
check_square($t0, $t3, $t4)
lw	$t6, ($sp)
lw	$t8, 4($sp)
lw	$t9, 8($sp)
addi	$sp, $sp, 12
beq	$v0, 2, blackKingInCheck
j	endBlackCheck

blackKingInCheck:
li	$v0, 1
j	endBlackCheck2
endBlackCheck:
li	$v0, 0
endBlackCheck2:

.end_macro

############################## COMPARE SQUARE ##################################

# Compares a square in two different positions. Returns 1 if they are the same, and 0 if they are different.
.macro	compare_square(%x, %y, %p1, %p2)

add	$t0, $zero, %y
sll	$t0, $t0, 3
add	$t0, $t0, %x
add	$t1, $t0, %p1
add	$t2, $t0, %p2
lb	$t3, ($t1)
lb	$t4, ($t2)
beq	$t3, $t4, compareSame
li	$v0, 0
j	endCompareSquare
compareSame:
li	$v0, 1
endCompareSquare:

.end_macro

############################## UPDATE CACHE COUNT ##################################

.macro	update_cache_count

subi	$s5, $s7, 0x10040000
sra	$s5, $s5, 6
bgt	$s5, 105, makeCacheCount120
j	endUpdateCacheCount
makeCacheCount120:
li	$s5, 105
endUpdateCacheCount:

.end_macro

