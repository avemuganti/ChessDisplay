.include "ChessMacros.asm"

.eqv	MEM	0x10000000
.eqv	BROWN	0x0078563c
.eqv	OWHITE	0x00c4a988
.eqv	BLACK	0x00433b38
.eqv	WHITE	0x00e3d3c0
.eqv	BROWNH	0x00a17c33
.eqv	OWHITEH	0x00c7a355

# The bitmap will be 512 x 512, with 4 x 4 units.

.data

staPosit:	.byte	-4, -2, -3, -5, -6, -3, -2, -4,
			-1, -1, -1, -1, -1, -1, -1, -1,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 1,  1,  1,  1,  1,  1,  1,  1,
			 4,  2,  3,  5,  6,  3,  2,  4

test:	.byte		 0,  0,  0,  0, -6,  0,  0, -4,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 0,  0,  0,  0,  0,  0,  0,  0,
			 1,  1,  1,  1,  1,  1,  1,  1,
			 4,  2,  3,  5,  6,  3,  2,  4

.text	

li	$a0, 786432
li	$v0, 9
syscall
li	$s1, 1 # s1 is 1 if we are playing white, and is -1 if we are playing black.
move	$s5, $zero # s5 is the position cache counter. This represents the # of moves in cache.
li	$s7, 0x10040000 # s7 will be a "cache pointer" used to control and traverse the move cache.

draw_board(MEM, OWHITE, BROWN, OWHITEH, BROWNH)
la	$s0, staPosit
encache_position($s0)

bne	$s1, 1, loopTurnsBlack
loopTurnsWhite:

white_random_move
update_cache_count
beq	$v0, 1, endLoopTurns
draw_board(MEM, OWHITE, BROWN, OWHITEH, BROWNH)
subi	$a0, $s7, 64
draw_position($a0, WHITE, BLACK, MEM)
li	$v0, 32
li	$a0, 1000
syscall

black_random_move
update_cache_count
beq	$v0, 1, endLoopTurns
draw_board(MEM, OWHITE, BROWN, OWHITEH, BROWNH)
subi	$a0, $s7, 64
draw_position($a0, WHITE, BLACK, MEM)
li	$v0, 32
li	$a0, 1000
syscall

j	loopTurnsWhite

loopTurnsBlack:

white_random_move
update_cache_count
beq	$v0, 1, endLoopTurns
draw_board_b(MEM, OWHITE, BROWN, OWHITEH, BROWNH)
subi	$a0, $s7, 64
draw_position_b($a0, WHITE, BLACK, MEM)
li	$v0, 32
li	$a0, 1000
syscall

black_random_move
update_cache_count
beq	$v0, 1, endLoopTurns
draw_board_b(MEM, OWHITE, BROWN, OWHITEH, BROWNH)
subi	$a0, $s7, 64
draw_position_b($a0, WHITE, BLACK, MEM)
li	$v0, 32
li	$a0, 1000
syscall

j	loopTurnsBlack

endLoopTurns:

li	$v0, 10
syscall

