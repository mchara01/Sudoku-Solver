//************************************************************************
// Program Name	: Sudoku Solver using Recursive Backtracking.
// Programmer	: Marcos Charalambous
// Stud. ID	: 919077
// Date  Modif.	: 30/11/17
//************************************************************************
// Comments: Given a partially filled 9×9 2D array grid[9][9], the goal is 
// to assign digits (from 1 to 9) to the empty cells so that every row,
// column, and subgrid of size 3×3 contains exactly one instance of the 
// digits from 1 to 9.We solve Sudoku by one by one assigning numbers to 
// empty cells. Before assigning a number, we need to confirm that the same
// number is not present in current row, current column and current 3X3 subgrid. 
// If number is not present in respective row, column or subgrid, we can assign
// the number, and recursively check if this assignment leads to a solution or 
// not. If the assignment doesn't lead to a solution, then we try next number 
// for current empty cell. And if none of number (1 to 9) lead to solution, we 
// return false. 
//************************************************************************
.data

my_Table:	.space  324			// Defining space for 324ytes/81Words
Size:		.word	81			// The size of the table is 81
FileOpenMode: 	.string	"r"
FileName: 	.string	"test.txt"
fscanf_str: 	.string	"%d"
out_message_str:.string "%d "
new_line:	.string	"\n"
no_sol:		.string "NO SOLUTION TO THIS PROBLEM\n"
start:		.string "START_CLOCK:	%d\n"
end:		.string	"END_CLOCK:	%d\n"
time:		.string "TIME_TAKEN:	%d\n"

.text
.global	main

main:

	stp	x29, x30, [sp, -32]!	// First (!) move the stack pointer 32 bytes down (sp-32)
					// and then store double x29 and x30. 
					// (pre-index modes whih means apply the offset before accessing the memory)
	add	x29, sp, 0		// Copy the value of stack pointer to Frame Pointer
	
	ldr	w1, Size		// There are 128 Integer in thetable				
	adr	x0, my_Table		// Load the address of my_Table.			
	bl 	initTable		// Call Function initTable
	
	ldr 	w1, Size
	adr	x0, my_Table		// Load the address of my_Table.
	bl 	printTable		// Call Function printTable
	
	adr 	x0, new_line		// Load the address of new_line
	bl 	printf			// Call Function printf

	bl	clock			// Call Function clock
	mov	x19, x0			// Moves the content of x19 to x0.
	mov	x1, x19			// Moves the content of x19 to x1.
	adr	x0, start		// Load the address of start.
	bl	printf			// Call Function printf

	bl 	solveSudoku		// Call Function solveSuodoku
	cbz	x0, no_solution		// Compare to zero and branch to no_solution.

	bl	clock			// Call Function clock.
	mov	x20, x0			// Moves the content of x0 to x20.
	mov	x1, x20			// Moves the content of x20 to x1.
	adr	x0, end			// Load the address of end.
	bl	printf
	
	adr 	x0, new_line		// Load the address of new_line
	bl 	printf			// Call Function printf

	ldr 	w1, Size
	adr	x0, my_Table		// Load the address of my_Table.
	bl 	printTable		// Call Function printTable.
	
	sub	x1,x20,x19		// Subtract x19 from x20 and store in x1.
	adr	x0, time		// Load the address of time.
	bl	printf			// Call Function printf

	adr 	x0, new_line		// Load the address of new_line.
	bl 	printf			// Call Function printf.
	b	exit			// Branch to exit.
	
no_solution:
	adr	x0, no_sol		// Load the address of no_sol.
	bl	printf			// Call Function printf.
exit:
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret				// Return to loading function

//**************************************************************************
initTable:
	stp	x29, x30, [sp, -32]!	// First (!) move the stack pointer 32 bytes down (sp-32)
					// and then store double x29 and x30. 
					// (pre-index modes whih means apply the offset before accessing the memory)
	add	x29, sp, 0		// Copy the value of stack pointer to Frame Pointer
	
	mov 	x21, x0			// Moves the content of x0 to x21.
	adr	x1, FileOpenMode	// Open the File Pointer.
	adr	x0, FileName		// Open the File Pointer.
	bl	fopen			// Call function fopen.
	mov 	x20, x0			// Store the file pointer into X20.
	mov 	x22, 81			// Moves number 81 in x22.

loop_init:
	add	x2, x29, 28		// The Location that fscanf will store the value
	adr	x1, fscanf_str		// Load the address of fscan_str.
	mov	x0, x20			// The File pointer
	bl	fscanf			// Call function fscanf.
	ldr	w1, [x29, 28]		// Get the value from the stack
	str 	w1, [x21], 4		// Store w1 in x21 and move up 4 bytes(post intex).
	sub	x22, x22, 1		// Subtract 1 from x22 and store in x22.
	cbnz	x22,loop_init		// Compare and branch if not zero.

	mov	x0, x20			// Get the File pointer
	bl	fclose			// Close the file.
	

	ldp	x29, x30, [sp], 32	// Release the stack space
	ret				// Return to loading function
//**************************************************************************************
//**************************************************************************************
printTable:
	stp	x29, x30, [sp, -32]!	// First (!) move the stack pointer 32 bytes down (sp-32)
					// and then store double x29 and x30. 
					// (pre-index modes whih means apply the offset before accessing the memory)
	add	x29, sp, 0		// Copy the value of stack pointer to Frame Pointer

	str	x19, [x29, 20]		// Store x19 in x29 with offset 20.
	str	x20, [x29, 24]		// Store x20 in x29 with offset 24.
	str	x21, [x29, 28]		// Store x21 in x29 with offset 28.

	mov 	x19, x0			// Moves the content of x0 to x19.
	mov	x20, x1			// Moves the content of x1 to x20.
	mov 	x21, xzr 		// Moves the content of xzr to x21.
	adr	x0, out_message_str	// Load the address of out_message_str.

loop_print:
	adr	x0, out_message_str	// Load the address of out_message_str.
	ldr	w1, [x19], 4		// Load in w1 from x19 and move up 4 bytes(post intex).
	bl 	printf			// Call Function printf.
	add	x20, x20, -1		// ADD -1 on the contents of x20.
	add	x21, x21, 1		// ADD 1 on the contents of x21.
	cmp	x21, 9			// Compare x21 with 9.
	b.eq 	newLine			// Branch if equal to newLine.
	cbnz	x20, loop_print		// Compare and branch if not zero.

newLine:
	adr 	x0, new_line		// Load the address of new_line.
	bl 	printf			// Call Function printf.
	mov 	x21, xzr		// Moves the content of xzr to x21.
	cbnz	x20, loop_print		// Compare and branch if not zero.

	ldr	x19, [x29, 20]		// Load in x19 from x29 with offset 20.
	ldr	x20, [x29, 24]		// Load in x20 from x29 with offset 24.
	ldr 	x21, [x29, 28]		// Load in x21 from x29 with offset 28.
	
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret				// Return to loading function
//**************************************************************************************
//**************************************************************************************
solveSudoku:
	stp	x29, x30, [sp,-64]!	//BASIC BLOCK A
	add 	x29, sp, 0

	str	x19, [x29, 16]		
	str	x20, [x29, 24]
	str	x21, [x29, 32]		// Store x19-x24 from x29 with offset 16-56.
	str	x22, [x29, 40]
	str	x23, [x29, 48]
	str	x24, [x29, 56]

	adr	x19, my_Table		//my_Table base address.
	mov	x20, 0			//ROW COUNTER
	
loop1:

	mov	x11, 9			//Mov 9 in x11.
	mul	x22, x11, x20		//Multiply x11 with x20 and str in x22.
	mov	x21, 0			//COLUMN COUNTER

loop2:
	add	x23, x21, x22 		//Add x22 on x21 and str in x23.
	lsl	x23, x23, 2		//(ROW*9+COLUMN)*4
	
	ldr	w9, [x19, x23]		//Load in w9 from x19 with offset x23.
	cbnz	w9, else1		//sudoku[row][col]!=0
	mov	w24, 1			//NUMBERS COUNTER	

loop3:
	mov 	x0, x20			//BASIC BLOCK B
	mov 	x1, x21			//X0,X1,X2 PARAMETERS FOR isAllowed
	mov 	x2, x24			
	bl	isAllowed		//Call function isAllowed.
	cbz	x0, else2		//BASIC BLOCK C.
	
	str	w24, [x19,x23]		//Store number in table.
	
	bl	solveSudoku		//Call function solveSudoku.
	cbz	x0, else3		//BASIC BLOCK D

	ldr	x19, [x29, 16]
	ldr	x20, [x29, 24]
	ldr	x21, [x29, 32]
	ldr	x22, [x29, 40]		//Load in x19-x24 from x29 with offset 16-56.
	ldr	x23, [x29, 48]
	ldr	x24, [x29, 56]

	mov	x0, 1			//Move true value in x0.
	ldp	x29, x30, [sp], 64	// Release the stack space
	ret			 	// Return to loading function

else3:
	str	wzr, [x19, x23]		// BASIC BLOCK E

else2:
	add	w24, w24, 1		//Increase numbers counter by 1.
	cmp	w24, 10			//Compare current number with 10.
	b.lt	loop3			//Branch if less than.

	ldr	x19, [x29, 16] 		//BASIC BLOCK F
	ldr	x20, [x29, 24]
	ldr	x21, [x29, 32]
	ldr	x22, [x29, 40]		//Load in x19-x24 from x29 with offset 16-56.
	ldr	x23, [x29, 48]
	ldr	x24, [x29, 56]

	mov	x0, 0			//FALSE	value in x0.
	ldp	x29, x30, [sp], 64	// Release the stack space
	ret				// Return to loading function
		
else1:
	add	x21, x21, 1		//COLUMN++
	cmp	x21, 9			//BASIC BLOCK G
	b.lt	loop2			//Branch if less than.	
	
	add  	x20, x20, 1		//ROW++
	cmp	x20, 9			//BASIC BLOCK H
	b.lt	loop1			//Branch if less than.

		
	ldr	x19, [x29, 16]		//BASIC BLOCK I
	ldr	x20, [x29, 24]
	ldr	x21, [x29, 32]
	ldr	x22, [x29, 40]		//Load in x19-x24 from x29 with offset 16-56.
	ldr	x23, [x29, 48]
	ldr	x24, [x29, 56]
	mov	x0, 1			//TRUE value in x0.

	ldp	x29, x30, [sp], 64	// Release the stack space
	ret			        // Return to loading function
//**************************************************************************************
//**************************************************************************************
containsInRow:				//PARAMETERS: x0 ROW, X1 NUMBER / BASIC BLOCK J
	stp 	x29, x30, [sp,-32]!	
	add 	x29, sp, 0
	
	mov	x9, 9			//Mov 9 in x11.
	mul 	x0, x0, x9		//Multiply x9 with x0 and str in x0.
	mov 	x3, xzr			//The counter tha will search the 9 columns.

	adr	x7, my_Table		//my_Table base address.

loop_row:
	add	x2, x0, x3		//Add x3 on x0 and store in x2.
	ldr	w4, [x7, x2 ,lsl 2]	//Load in w4, x7 with offset x2 afte shifting left by 2.
	cmp 	w4, w1			//Compare w4 with w1(number).
	b.eq	true_row		//Branch if equal.
	add 	x3, x3, 1		//BASIC BLOCK K
	cmp	x3, 8			//Check if counter reached 8.
	b.le 	loop_row		//Branch if less or equal.

	mov	x0, 0			//BASIC BLOCK L
	b	exit_row		//Branch to exit_row.
	
true_row:				//BASIC BLOCK M
	mov	x0, 1			// Move true value(1) to x0.
exit_row:
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret			        // Return to loading function
//**************************************************************************************
//**************************************************************************************
containsInCol:				//PARAMETERS: x0 COL, X1 NUMBER / BASIC BLOCK N
	stp 	x29, x30, [sp,-32]!
	add 	x29, sp, 0

	mov	x9, 9			//Mov 9 in x11.
	mov 	x3, xzr			//The counter tha will search the 9 rows.

	adr	x7, my_Table		//my_Table base address.


loop_col:
	mul	x5, x3, x9		//Multiply x9 with x3 and str in x5.
	add	x10, x5, x0		//Add x5 on x0 and store in x10.
	ldr	w4, [x7, x10, lsl 2]	//Loads the given row with the current column.
	cmp 	w4, w1			//Compare the number in my_Table with the given number.
	b.eq	true_col		//If not equal, then branch to cont_row. 
	add 	x3, x3, 1		// BASIC BLOCK 0
	cmp	x3, 8			//Check if counter reached 8.
	b.le 	loop_col		//Branch if less or equal.

	mov	x0, 0			//BASIC BLOCK P
	b	exit_col		//Branch to exit_col.

true_col:
	mov	x0, 1			//BASIC BLOCK Q
exit_col:
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret			        // Return to loading function
//**************************************************************************************
//**************************************************************************************
containsInBox:				//PARAMETERS: x0 ROW, X1 COLUMN, X2, NUMBER / BASIC BLOCK R
	stp 	x29, x30, [sp,-32]!	
	add 	x29, sp, 0

	mov 	x9, 3			// Move 3 in x9. 
	udiv	x10, x0, x9		// (row/3)
	mul	x11, x9, x10		// ((row/3)*3
	sub	x12, x0, x11		// (row-(row/3)*3)	
	sub	x3, x0, x12		// r
	

	udiv	x10, x1, x9		//same process for column.
	mul	x11, x9, x10
	sub	x12, x1, x11
	sub 	x4, x1, x12		// c
	
	add	x5, x3, 3		//Add 3 on r and store in x5.
	add	x6, x4, 3		//Add 3 on c and store in x6.

	adr	x7, my_Table		//my_Table base address.
loop1_box:
	mov	x11, 9			//Mov 9 in x11.
	mul	x10,x11,x3		//Multiply x11 with x3 and str in x10.
loop2_box:
	add	x9, x10, x4		//Add x4 on x10 and str in x9. 
	lsl	x9, x9, 2		//Shilf left the content of x9 by 2.
	
	ldr	w13, [x7, x9]		//Load in w13, x7 with offset x9.
	cmp	w13, w2			//check w13 if same as number.
	b.eq	true_box		//Branch if equal.
	add 	x4, x4, 1		//BASIC BLOCK S.
	cmp	x4, x6			//Compare x4 with x6.
	b.lt	loop2_box		//Branch if less than.
	
	add	x4, x4, -3		//BASIC BLOCK T
	add	x3, x3, 1		//Add 1 on x3.
	cmp	x3, x5			//Compare x3 with x5.
	b.lt	loop1_box		//Branch if less than.

	mov 	x0, 0			//BASIC BLOCK U
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret			        // Return to loading function

true_box:
	mov	x0, 1			//BASIC BLOCK V
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret			        // Return to loading function
//**************************************************************************************
//**************************************************************************************
isAllowed:				//Parameters: x0 ROW, X1 COLUMN, X2, NUMBER
	stp 	x29, x30, [sp,-32]!	//BASIC BLOCK W
	add 	x29, sp, 0
	
	str	w0, [x29, 28]		//Store row.
	str	w1, [x29, 24]		//Store column.
	str	w2, [x29, 20]		//Store number.

	ldr	w1, [x29, 20]		//Load number in w1.
	ldr	w0, [x29, 28]		//Load row in w0.

	bl 	containsInRow		//Call function containsInRow.
	cmp	w0, 0			//BASIC BLOCK X
	bne	false_value		//Branch if not equal to 0.
	
	ldr	w1, [x29, 20]		//BASIC BLOCK Y
	ldr	w0, [x29, 24]		//Load in w1 the number and w0 the col.
	bl	containsInCol		//Call function containsInCol.
	cmp	w0, 0			//BASIC BLOCK Z
	bne	false_value		//Branch if not equal.
	
	ldr	w2, [x29, 20]		//BASIC BLOCK A2
	ldr	w1, [x29, 24]		//Load in w2 the number and w1 the col.
	ldr	w0, [x29, 28]		//Load row in w0.
	bl	containsInBox		//Call function containsInBox.
	cmp	w0, 0			//BASIC BLOCK B2
	bne	false_value		//Branch if not equal to 0.
	mov	w0, 1			//BASIC BLOCK C2
	b	exit_allowed		//Branch to exit_allowed.

false_value:
	mov	w0, 0			//BASIC BLOCK D2
	
exit_allowed:
	ldp	x29, x30, [sp], 32	// Release the stack space
	ret			        // Return to loading function
//**************************************************************************************

