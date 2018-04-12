.data 
	userInfo1: .asciiz "Enter dd/mm/yyyy: "
	userInfo2: .asciiz "\nYou typed in: "
	userInput: .space 10
	lengthInput: .space 4
	time1_test: .asciiz "08/12/2018"
	time2_test: .asciiz "09/09/2016"

	#chien
	strData: .space 11
	newLine: .asciiz "\n"
	slash:	.byte	'/'
	
	msg_Invaild: .asciiz "The date inputed is invaild"
	msg_Vaild: .asciiz "The date inputed is Vaild"

#-------------------------------------------------------------

.text 
main:
	la $a0, time2_test
	la $a1, time1_test
	
	jal LeapYear
	
	add $a0, $v0, $0
	addi $v0, $0, 1
	syscall
	
	#Tho�t chuong tr�nh
	li $v0, 10
	syscall
	

#-------------------------------------------------------------

Day:	
	add $t0, $zero, $0
	addi $t1, $zero, 10
	LoopDay:
		lb $t2, 0($a0)		#ky tu trong $a0
		addi $t2, $t2, -48
		# t2 < '0' -> exit
		slt $t3, $t2, $0
		beq $t3, 1, ExitLoopDay
		
		# t0 = t0 * t1 + t2 = t0 * 10 + t2
		mult $t0, $t1
		mflo $t0		#Nho hon 32bit
		add $t0, $t0, $t2
		addi $a0, $a0, 1
		j LoopDay
	ExitLoopDay:
	
	add $v0, $t0, $0			#Luu $v0 de tra ve		
	
	#thoat thu tuc
	jr $ra

#-------------------------------------------------------------	
Month:	
	add $t0, $zero, $0
	addi $t1, $zero, 10	#bien tam gan = 10
	#Di den so cua month
	GoMonth:
		lb $t2, 0($a0)
		addi $a0, $a0, 1	#$a0++
		beq $t2, 47, LoopMonth	#Ky tu '/' dau tien		
		j GoMonth

	LoopMonth:
		lb $t2, 0($a0)
		addi $t2, $t2, -48
		slt $t3, $t2, $0
		beq $t3, 1, ExitLoopMonth		
		mult $t0, $t1
		mflo $t0
		add $t0, $t0, $t2
		addi $a0, $a0, 1
		j LoopMonth
	ExitLoopMonth:
	
	add $v0, $t0, $0
	
	jr $ra

#-------------------------------------------------------------
Year:
	add $t0, $zero, $0	#Ket qua
	addi $t1, $zero, 10	#bien tam gan = 10
	add $t3, $zero, $0	#Dem ky tu '/'
	#Di den so cua year
	GoYear:
		lb $t2, 0($a0)
		addi $a0, $a0, 1	#$a0++
		bne $t2, 47, Continue	#Ky tu '/' 			
		addi $t3, $t3, 1	#Tang dem ky tu '/'
		Continue:
			beq $t3, 2, LoopYear	
		j GoYear

	LoopYear:
		lb $t2, 0($a0)	
		addi $t2, $t2, -48
		#bltz $t2, ExitLoopYear	#Neu la ky tu ket thuc chuoi '\0' || < 0
		slt $t3, $t2, $0	#$t3 = 1 if ($t2<0)
		beq $t3, 1, ExitLoopYear
			
		mult $t0, $t1		#lo = $s0 * 10 
		mflo $t0	
		add $t0, $t0, $t2			
		addi $a0, $a0, 1
		j LoopYear
	ExitLoopYear:
	
	add $v0, $t0, $0	
	
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

	lw	$a0, 0($sp)
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
	
	lw	$s0, 0($sp)

	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	addi	$sp, $sp, -4
	sw	$s0, 0($sp)
	
	
	#test, need to replace a0 = getDay, a1 = getMonth, a2= getYear
	#addi 	$a0, $0, 12

	jal Day
	move 	$a0, $v0
	

	#addi	$a1, $0, 2
	
	jal Month
	move 	$a1, $v0
	
	
	#addi	$a2, $0, 2012	
	
	jal Year
	move 	$a2, $v0
	
	#check
	slti	$t3, $a0, 1
	bne	$t3, $0, checkLogic_invaild	#day < 1
	slti	$t3, $a1, 1
	bne	$t3, $0, checkLogic_invaild	#month < 1
	slti	$t3, $a2, 1
	bne	$t3, $0, checkLogic_invaild	#year < 1
	slti	$t3, $a1, 13
	beq	$t3, $0, checkLogic_invaild	#month <= 12
	
	addi	$sp, $sp, -8
	sw	$a1, 0($sp)
	sw	$a2, 4($sp)
	jal	month_number	#get the mumber of month
	add	$t4, $v0, $0	#$t4 = number of mOnth 

	slt	$t3, $t4, $a0
	bne	$t3, $0, checkLogic_invaild	#day <= numberofmonth
	

	addi 	$sp, $sp, 8 
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4

	checkLogic_vaild:	#return true
		addi	$v0, $0, 1
		jr	$ra
	checkLogic_invaild:	#return false
		addi 	$v0, $0, 0
		jr	$ra

# a0: month, a1: year
month_number:
	addi $t0, $a0, -1
	beq	$t0, $0, cs31 # month = 1
	
	addi $t0, $a0, -3
	beq	$t0, $0, cs31 # month = 3
	
	addi $t0, $a0, -5
	beq	$t0, $0, cs31 # month = 5
	
	addi $t0, $a0, -7
	beq	$t0, $0, cs31 # month = 7
	
	addi $t0, $a0, -8
	beq	$t0, $0, cs31 # month = 8
	
	addi $t0, $a0, -10
	beq	$t0, $0, cs31 # month = 10
	
	addi $t0, $a0, -12
	beq	$t0, $0, cs31 # month = 12

	addi $t0, $a0, -4
	beq	$t0, $0, cs30 # month = 4
	
	addi $t0, $a0, -6
	beq	$t0, $0, cs30 # month = 6
	
	addi $t0, $a0, -9
	beq	$t0, $0, cs30 # month = 9
	
	addi $t0, $a0, -11
	beq	$t0, $0, cs30 # month = 11

	# month = 2
	addi $sp, $sp,  -4
	jal	is_leap
	add	$t2, $v0, $0	#if leap() then t2 = 1
	beq	$t2, $0, cs28	#if leap == false
	addi	$v0, $0, 29
	j end_chklg

	cs28:
		addi $v0, $0, 28
		j end_chklg
	cs31:
		addi $v0, $0, 31
		j end_chklg
	cs30:
		addi $v0, $0, 30
		j end_chklg

end_chklg:
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8

	jr	$ra
###################################################################
# a0: year
is_leap:
	addi	$t0, $0, 400
	div	$a0, $t0
	mfhi	$t0
	beq 	$t0, $0, leap_true	#if year % 400 == 0 -> true
	
	addi $t0, $0, 4
	div 	$a0, $t0
	mfhi	$t0
	bne	$t0, $0, leap_false	#if year % 4 !=0 -> false
	
	addi $t0, $0, 100
	div 	$a0, $t0
	mfhi	$t0
	bne	$t0, $0, leap_true	#if year % 100 !=0 -> true

	leap_false:
		add $v0, $0, $0
		jr	$ra

	leap_true:
		addi $v0, $0, 1
		jr $ra

###################################################################
# a0: time
LeapYear:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal Year
	add $a0, $v0, $0
	
	jal is_leap
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

#################################################
printNewLine:
	#print newline
	addi	$v0, $0, 4
	la	$a0, newLine
	syscall

	jr	$ra

#################################################
# $a0: time1, $a1: time2
get_time:
	# top = $ra -> $a1 -> $a0
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	jal Year
	add $s0, $v0, $0
	
	# top = $ra -> $s0 -> $a0
	lw $a0, 4($sp)
	sw $s0, 4($sp)
	
	jal Year
	add $s1, $v0, $0
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	sub $v0, $s0, $s1
	slt $t0, $v0, $0
	beq $t0, $0, exit_get_time
	sub $v0, $0, $v0
	exit_get_time:
		jr $ra