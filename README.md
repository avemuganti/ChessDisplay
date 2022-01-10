# ChessDisplay

When run, the program generates a random chess game. All moves in the game should be legal, and the game will end if there is a checkmate, stalemate, or draw by repetition/insufficient material/50-move rule.

MARS (MIPS Assembly and Runtime Simulator) was used to run this program. In order to run this correctly, both files should be in the same directory within MARS. Additionally, before running, you must open the bitmap display to see any results.

Once the program has been assembled (but not yet run), open the "Tools" dropdown, and select "Bitmap Display". A menu should open that displays options for the bitmap display. Set the unit width and height to 4px, and he display width and height to 512px. Additionally, set the "Base address for display" to 0x10000000 (global data). Then press "Connect to MIPS" in the bottom left-hand corner of the bitmap window.

To see the entirety of the chessboard, resize the bitmap window such that the entire 512 x 512 area of the display can be seen.

You may now run the program. The two "players" make random moves, without any regard for strategy. However, all moves that are made should be legal, including moves that occur when either king is in check.
