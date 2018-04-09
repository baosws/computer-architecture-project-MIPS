.data 
	userInfo1: .asciiz "Enter dd/mm/yyyy: "
	userInfo2: .asciiz "\nYou typed in: "
	userInput: .space 10
	lengthInput: .space 4


	#chien
	strData: .space 11
	newLine: .asciiz "\n"
	slash:	.byte	'/'
	
	msg_Invaild: .asciiz "The date inputed is invaild"
	msg_Vaild: .asciiz "The date inputed is Vaild"

#-------------------------------------------------------------

.text 
main:
	la $a0, userInfo1
	li $v0, 4 		#in ra man hinh userInfo1
	syscall	
	
	jal 	inputDate
	add	$s0, $v0, $0	#$s0 = stringDate
	
	addi	$v0, $0, 4	
	add	$a0, $s0, $0
	syscall
	
	
	#Thoát chuong trình
	li $v0, 10
	syscall
	

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

##################################################################################################
inputDate: #input string to $s0
	#read in string
	addi	$v0, $0, 8
	la	$a0, strData
	addi	$a1, $0, 11
	syscall
	
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)	

	jal	checkSyntax
	add	$t0, $v0, $0	#if $t0 = 0 -> syntax error
	beq	$t0, $0, invaild

	
	#checklogic
	
	jal	checkLogic
	add	$t0, $v0, $0	#if $t0 = 0 -> syntax error
	beq	$t0, $0, invaild


	#vaild:
	lw	$v0, 0($sp) 	#return $a0	
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra

	invaild:
		addi	$v0, $0, 4
		la	$a0, msg_Invaild
		syscall
		j 	exit	

	exit:
	addi 	$v0, $0, 10
	syscall	

#################################################
checkSyntax:	#bool check(string str)

	addi	$t4, $0, 47	# slash '/'
	addi	$t5, $0, 57	# character '9'

	add	$t0, $0, $0 	#	i=0
	add	$t6, $0, $0	#	count_slash=0

        loop_st:
	
	#slti	$t1, $t0, 10	#	if i < 10 -> t1 = 1
	#beq	$t1, $0, out_st	#	if i >= 10 -> break
	add	$t1, $a0, $t0	#	t1 = a0 + t0 <=> t1 = str+i
	lb	$t2, 0($t1)	#	t2 = str[i]
	
	addi	$t1, $t2, -10	#	t1 = (str[i] == '\n')
	beq	$t1, $0, out_st

	#check here
	slt	$t1, $t2, $t4	#	t1 = (str[i] < 47)
	bne	$t1, $0, end_st
	slt	$t1, $t5, $t2	#	t1 = (57 < str[i])
	bne	$t1, $0, end_st	#	if t1==1 -> return false
	
	sub	$t1, $t2, $t4
	bne	$t1, $0, skip	#	if(str[i]=='/')
	addi	$t6, $t6, 1	#	count++
	skip:	

	addi	$t0, $t0, 1	# 	i++
	j	loop_st
	
	out_st:	#return true
		add	$t2, $0, $0	# replace '\n' = 0
		addi	$t6, $t6, -2	#if(count!=2) return false
		bne	$t6, $0, end_st
		addi	$v0, $0, 1
		jr	$ra
	end_st:	#return false
		addi 	$v0, $0, 0
		jr	$ra

#################################################	
checkLogic:	#bool checkLogic(string str) str=$a0
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	addi	$sp, $sp, -4
	sw	$s0, 0($sp)
	
	jal	Day
	add	$t0, $v0, $0	#	$t0 = day
	li	$v0, 1
	add	$a0, $t1, $0
	syscall 



	jal	Month
	add	$t1, $v0, $0	#	$t1 = month
	li	$v0, 1
	add	$a0, $t2, $0
	syscall

	jal	Year
	add	$t2, $v0, $0	#	$t2 = year
	li	$v0, 1
	add	$a0, $t1, $0
	syscall 

	
	
	 


	lw	$s0, 0($sp)
	addi	$sp, $sp, 4

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4

	out_lg:	#return true
		addi	$v0, $0, 1
		jr	$ra
	end_lg:	#return false
		addi 	$v0, $0, 0
		jr	$ra


#################################################
printNewLine:
	#print newline
	addi	$v0, $0, 4
	la	$a0, newLine
	syscall

	jr	$ra
