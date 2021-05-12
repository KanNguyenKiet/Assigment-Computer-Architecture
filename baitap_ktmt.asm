	.data
nt: 	.asciiz	" nguyen to\n"
knt:	.asciiz " khong nguyen to\n"
so:	.asciiz	"so "
num1:	.asciiz	"0000"	
num2:	.asciiz	"0000"
num3:	.asciiz	"0000"
fout:	.asciiz	"nguyento.txt"

	.text
	
	.globl	main
	
main:
	#mo file
	li 	$v0, 13 	# system call for open file
 	la 	$a0, fout 	# output file name
	li 	$a1, 1 		# Open for writing (flags are 0: read, 1: write)
	li 	$a2, 0 		# mode is ignored
	syscall 		# open a file (file descriptor returned in $v0)
 	move 	$s6, $v0 	# save the file descriptor
 	
	j	program
	
	#ham sinh so ngau nhien
	#ket qua luu vao $a0
ngaunhien:
	addi	$a0, $zero, 0
	addi	$a1, $zero, 10000
	addi 	$v0, $zero, 42
	syscall
	jr	$ra
	
	#ham chuyen so thanh xau
	#tham so dau vao la $t0
	#ket qua luu trong $s0
xau:	
	#lay chu so thu 4
	addi 	$s1, $zero, 10 
	div	$t0, $s1
	mfhi	$t4
	mflo	$t0
	addi	$t4, $t4, 48	#chuyen chu so sang ki tu
	sb	$t4, 3($s0)
	
	#lay chu so thu 3
	div	$t0, $s1
	mfhi	$t4
	mflo	$t0
	addi	$t4, $t4, 48	#chuyen chu so sang ki tu
	sb	$t4, 2($s0)
	
	#lay chu so thu 2
	div	$t0, $s1
	mfhi	$t4
	mflo	$t0
	addi	$t4, $t4, 48	#chuyen chu so sang ki tu
	sb	$t4, 1($s0)
	
	#lay chu so thu 1
	div	$t0, $s1
	mfhi	$t4
	mflo	$t0
	addi	$t4, $t4, 48	#chuyen chu so sang ki tu
	sb	$t4, 0($s0)
	jr	$ra
	
	# ham kiem tra nguyen to
	#tham so dau vao $t0
kiemtranguyento:
	#bien dem $t4
	addi 	$t4, $zero, 2
for:
	div 	$t0, $t4
	mfhi	$t5
	bnez	$t5, next
	#in ra ket qua khong la so nguyen to
	li 	$v0, 15 	# system call for write to file
	move 	$a0, $s6 	# file descriptor
	la 	$a1, so 	# address of buffer from which to write
	li 	$a2, 2	 	# hardcoded buffer length
	syscall 		# write to file 
 
 
 
 
	move 	$a0, $t0
	addi 	$v0, $zero, 1
	syscall
	la	$a0, knt
	addi 	$v0, $zero, 4
	syscall
	jr	$ra
	
next:
	addi	$t4, $t4, 1
	beq	$t4, $t0, endfor
	j	for
endfor:
	#in ket qua la so nguyen to 
	la	$a0, so
	addi 	$v0, $zero, 4
	syscall
	move 	$a0, $t0
	addi 	$v0, $zero, 1
	syscall
	la	$a0, nt
	addi 	$v0, $zero, 4
	syscall
	jr	$ra
	
program:
	#goi ham ngau nhien de sinh so n_1
	jal	ngaunhien
	addu 	$t1, $a0, $zero
	
	#goi ham ngau nhien de sinh so n_2
	jal	ngaunhien
	addu 	$t2, $a0, $zero
	
	#goi ham ngau nhien de sinh so n_3
	jal	ngaunhien
	addu 	$t3, $a0, $zero
	
	#chuyen so n_1 thanh xau
	move	$t0, $t1
	la	$s0, num1
	jal	xau
	
	#chuyen so n_2 thanh xau
	move	$t0, $t2
	la	$s0, num2
	jal	xau
	
	#chuyen so n_3 thanh xau
	move	$t0, $t3
	la	$s0, num3
	jal	xau
	
	#kiem tra n_1 co nguyen to hay khong
	move	$t0, $t1
	jal	kiemtranguyento
	
	#kiem tra n_2 co nguyen to hay khong
	move	$t0, $t2
	jal	kiemtranguyento
	
	#kiem tra n_2 co nguyen to hay khong
	move	$t0, $t3
	jal	kiemtranguyento
	
	#dong file 
	li 	$v0, 16 	# system call for close file
	move 	$a0, $s6 	# file descriptor to close
	syscall 		# close file
	
