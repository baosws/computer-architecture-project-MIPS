.data 
	userInfo1: .asciiz "Enter dd/mm/yyyy: "
	userInfo2: .asciiz "\nYou typed in: "
	userInput: .space 10
	lengthInput: .space 4
	
#-------------------------------------------------------------

.text 
	la $a0, userInfo1
	li $v0, 4 		#in ra man hinh userInfo1
	syscall	
	
	la $a0, userInput	#dia chi cua userInput gán vào $a0
	la $a1, lengthInput	#?? dài c?a chu?i nh?p vô
	li $v0, 8 		#nhap ngay thang nam tu nguoi dung
	syscall
	
	#move $s0, $a0
	jal Year		#Tra ve tai $v0
	move $a0, $v0		
	
	li $v0, 1
	syscall
	#In ra man hinh user nhap
	#la $a0, userInfo2
	#li $v0, 4
	#syscall 

	#la $a0, userInput
	#li $v0, 4
	#syscall
	
	
	#Thoát chuong trình
	li $v0, 10
	syscall
	
#-------------------------------------------------------------

.globl main
main: 

#-------------------------------------------------------------

Day:
	#Luu cac bien duoc su dung trong stack
	addi $sp, $sp, -10
	sb $a0, 0($sp)		#Luu bien $a0
	
	
	#Lay Day tu char* TIME
	add $s0, $zero, $0
	addi $t0, $zero, 10
	LoopDay:
		lb $t1, 0($a0)		#L?y ký t? ??u tiên 	
		sub $s1, $t1, 48
		bltz $s1, ExitLoopDay	#Neu kí tu là '/' thì thoat		
		mult $s0, $t0
		mflo $s0		#Nho hon 32bit
		add $s0, $s0, $s1
		addi $a0, $a0, 1
		j LoopDay
	ExitLoopDay:
	
	move $v0, $s0			#Luu $v0 = $s1 de tra ve
	
	#Pop cac dia chi ra khoi stack theo thu tu nguoc voi Push
	lb $a0, 0($sp)
	addi $sp, $sp, 10
	
	#thoat thu tuc
	jr $ra

#-------------------------------------------------------------	
Month:
	#Luu cac bien duoc su dung trong stack
	subu $sp, $sp, 4
	sw $t0, ($sp)
	
	#Lay Month tu char* TIME
	add $s0, $zero, $0	
	addi $t0, $zero, 10	#bien tam gan = 10
	#Di den so cua month
	GoMonth:
		lb $t1, 0($a0)
		addi $a0, $a0, 1	#$a0++
		beq $t1, 47, LoopMonth	#Ky tu '/' dau tien		
		j GoMonth
			
	LoopMonth:
		lb $t1, 0($a0)
		sub $s1, $t1, 48
		bltz $s1, ExitLoopMonth	#La ky tu '/'			
		mult $s0, $t0
		mflo $s0
		add $s0, $s0, $s1
		addi $a0, $a0, 1
		j LoopMonth
	ExitLoopMonth:
	
	move $v0, $s0	
	#Lay các dia chi ra khii stack
	lw $t0, ($sp)
	addu $sp, $sp, 4
	
	jr $ra

#-------------------------------------------------------------
Year:
	#Luu cac bien duoc su dung trong stack
	subu $sp, $sp, 4
	sw $t0, ($sp)
	
	#Lay Year tu char* TIME
	add $s0, $zero, $0	
	addi $t0, $zero, 10	#bien tam gan = 10
	add $t1, $zero, $0	#Dem ky tu '/'
	#Di den so cua year
	GoYear:
		lb $t2, 0($a0)
		addi $a0, $a0, 1	#$a0++
		bne $t2, 47, Continue	#Ky tu '/' 			
		addi $t1, $t1, 1	#Tang dem ky tu '/'
		Continue:
		beq $t1, 2, LoopYear	
		j GoYear
			
	LoopYear:
		lb $t2, 0($a0)
		sub $s1, $t2, 48		
		mult $s0, $t0		#lo = $s0 * 10 
		mflo $s0	
		add $s0, $s0, $s1			
		addi $a0, $a0, 1
		beq $a0, $a1, ExitLoopYear	#neu chay toi cuoi do dai chuoi
		j LoopYear
	ExitLoopYear:
	
	move $v0, $s0	
	#Lay các dia chi ra khoi stack
	lw $t0, ($sp)
	addu $sp, $sp, 4
	
	jr $ra
#-------------------------------------------------------------
