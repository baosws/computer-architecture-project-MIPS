.data 
	#Input 
	message0: .asciiz "----Ban hay chon mot trong cac thao tac duoi day (1-6): \n"
	message1: .asciiz "1.Xuat chuoi TIME theo dinh dang dd/mm/yyyy\n"
	message2: .asciiz "2.Chuyen doi chuoi TIME theo mot trong cac dinh dang:\n"
	message2_0: .asciiz "Chon kieu dinh dang(A||B||C): "
	message2_1: .asciiz "\tA. MM/DD/YYYY\n"
	message2_2: .asciiz "\tB. Month DD, YYYY\n"
	message2_3: .asciiz "\tC. DD Month, YYYY\n"
	message3: .asciiz "3.Cho biet ngay vua nhap la ngay thu may trong tuan\n"
	message4: .asciiz "4.Kiem tra co phai nam Nhuan\n"
	message5: .asciiz "5.Cho biet khong thoi gian giua chuoi TIME_1 va TIME_2\n"
	message6: .asciiz "6.Cho biet hai nam nhuan gan nhat voi nam trong chuoi\n"
	
	messageInput: .asciiz "Nhap lua chon: "
	messageResult: .asciiz "Ket qua: "
	errorMessage: .asciiz "\nSai dinh dang. Nhap lai: "
	userInput: .space 1
	timeInput: .space 10
	
	LeapYear1: .asciiz "La nam nhuan"
	LeapYear2: .asciiz "Khong phai nam nhuan"
	
	time1_test: .asciiz "08/12/2018"
	time2_test: .asciiz "14/4/1903"

	#chien
	strData: .space 11
	newLine: .asciiz "\n"
	slash:	.byte	'/'
	space:	.byte ' '
	
	msg_inp_day: .asciiz "Input Day: "
	msg_inp_month: .asciiz "Input Month: "	
	msg_inp_year: .asciiz "Input Year: "

	msg_Invaild: .asciiz "The date inputed is invaild"
	msg_Vaild: .asciiz "The date inputed is Vaild"
	
	

	Sun: .asciiz "Sun"
	Mon: .asciiz "Mon"
	Tue: .asciiz "Tue"
	Wed: .asciiz "Wed"
	Thurs: .asciiz "Thurs"
	Fri: .asciiz "Fri"
	Sat: .asciiz "Sat"
#-------------------------------------------------------------

.text 
main:
<<<<<<< HEAD
	jal  inputDate
	#string date is stored in $v0
	
	add	$a1, $v0, $0

	addi	$v0, $0, 4
	la	$a0, msg_Vaild
	syscall

	addi	$v0, $0, 4
	add	$a0, $a1, $0
	syscall
	
	




	la $a0, time2_test
	la $a1, time1_test
=======
	##--------Input information-----------
	addi	$v0, $0, 4
	la	$a0, message0	
	syscall
>>>>>>> 03993aa99818e7e28d90e0008bad71a6cd91e429
	
	la	$a0, message1	
	syscall
	
	la	$a0, message2	
	syscall
	
	la	$a0, message2_1
	syscall
	
	la	$a0, message2_2
	syscall
	
	la	$a0, message2_3
	syscall
	
	la	$a0, message3	
	syscall
	
	la	$a0, message4
	syscall
	
	la	$a0, message5	
	syscall
	
	la	$a0, message6	
	syscall
	
	#---- Read Input ----
	addi 	$v0, $0, 4
	la 	$a0, messageInput

	GetInput:	
	addi	$v0, $0, 12	#read char
	#addi	$a1, $0, 10
	#la	$a0, timeInput
	syscall
	
	add $t0, $0, $v0
	addi $t0, $t0, -48
	addi $t2, $zero, 1
	slt	$t1, $t0, $t2	#if $a0<$0 then $t0 =1 else $t0 = 0
	beq	$t1, 1, ShowError
	
	addi	$t2, $zero, 6	#$t2= 9
	slt	$t1, $t2, $t0	#if 9 < $t0 then $t1 =1
	beq	$t1, 1, ShowError
	
	j ExitGetInput
	
	ShowError:
		addi	$v0, $0, 4
		la 	$a0, errorMessage
		syscall
		j GetInput
	
	ExitGetInput:
	
	#-----Call function --------
	#Callfunc:
	#addi $t0, $0, 3
	
	addi	$t2, $0, 2		
	bne	$t0, $t2, Case2		#if $t0!= 1 goto Case2 
		#jal Date		#goi ham Date return char* TIME		
		add	$a0, $0, $v0
		addi	$v0, $0, 4
		syscall
		j ExitProgram	
	Case2:
		addi	$t2, $t2, 1	#if $t0!=2 goto Case3
		bne	$t0, $t2, Case3
		
		
		j ExitProgram
	Case3:
		addi	$t2, $t2, 1	#if $t0!=3 goto Case4
		bne	$t0, $t2, Case4
		jal 	WeekDay	
		add	$a0, $0, $v0
		addi	$v0, $0, 4
		syscall		
		j ExitProgram
	Case4:
		addi	$t2, $t2, 1	
		bne	$t0, $t2, Case5
		jal	LeapYear		
		
		add	$t3, $0, $v0
		addi	$v0, $0, 4
		beq	$t3, $0, NotLeapYear
		la	$a0, LeapYear1	
		j PrintLeapYear
		NotLeapYear:
			la	$a0, LeapYear2
		PrintLeapYear: syscall
		
		j ExitProgram
	#khoang time giua hai char* TIME
	Case5:	
		addi	$t2, $t2, 1	
		bne	$t0, $t2, Case6
		
		
		j ExitProgram
	Case6:
		jal	NeareastLeapYears
		add	$a0, $0, $v0
		addi	$v0, $0, 1
		syscall
		
		addi	$v0, $0, 11
		la	$a0, space
		syscall
		
		add	$a1, $0, $v1
		addi	$v0, $0, 1
		syscall
			
		j ExitProgram
	
	#Tho�t chuong tr�nh
	ExitProgram:
		li	$v0, 10
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
string_to_int:
	lw	$a0, 0($sp)	#strin
	
	addi 	$t0, $0, 0	#i=0
	addi	$v0, $0, 0
	addi	$t4, $0, 10
	loop_str_to_int:
	slti 	$t1, $t0, 4	#t1 = (i<4)
	beq	$t1, $0, return_true_str_to_int
	
	add	$t1, $a0, $t0	#	t1 = a0 + t0 <=> t1 = str+i
	lb	$t2, 0($t1)	#					t2 = str[i]
	
	addi	$t1, $t2, -10	#	t1 = (str[i] == '\n')
	beq	$t1, $0, return_true_str_to_int
	
	#check here
	slti	$t1, $t2, 48	#	t1 = (str[i] < 48) ('0' = 48)
	bne	$t1, $0, return_false_str_to_int
	slti	$t1, $t2, 58	#	t1 = (str[i]<58)
	beq	$t1, $0, return_false_str_to_int	#	if t1==1 -> return false
	
	mul	$v0, $v0, $t4	#v0 = v0*10
	addi	$t1, $t2, -48
	add 	$v0, $v0, $t1	#v0 = v0*10+(str[i] - 48)
	
	addi 	$t0, $t0, 1
	j	loop_str_to_int
	
	return_true_str_to_int:
		jr	$ra
	return_false_str_to_int:
		addi 	$v0,$0, -1
		jr	$ra
##################################################################################################
inputDate: 

	#print "input day"
	la $a0, msg_inp_day
	addi $v0, $0, 4
	syscall

	#read in Day
	addi	$v0, $0, 8
	la	$a0, strData
	addi	$a1, $0, 11
	syscall
	
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)	
	sw	$ra, 4($sp)

	jal 	string_to_int
	add	$t5, $v0, $0	#t5 = day
	addi	$sp, $sp, 4
	

	#print "input MONTH"
	la 	$a0, msg_inp_month
	addi 	$v0, $0, 4
	syscall

	#read in Month
	addi	$v0, $0, 8
	la	$a0, strData
	addi	$a1, $0, 11
	syscall
	
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)	

	jal 	string_to_int
	add	$t6, $v0, $0	#t6 = month
	addi	$sp, $sp, 4

	#print "input YEAR"
	la $a0, msg_inp_year
	addi $v0, $0, 4
	syscall

	#read in YEAR
	addi	$v0, $0, 8
	la	$a0, strData
	addi	$a1, $0, 11
	syscall
	
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)	

	jal 	string_to_int
	add	$t7, $v0, $0	#t7 = year
	add	$t2, $0, 2012
	addi	$sp, $sp, 4

	
	#checklogic
	addi 	$sp, $sp, -12
	sw	$t5, 0($sp)	#day
	sw	$t6, 4($sp)	#month	
	sw	$t7, 8($sp)	#year
		

	jal	checkLogic
	add	$t3, $v0, $0	#if $t0 = 0 -> syntax error

	beq	$t3, $0, invaild


	#vaild:
	jal	to_string
	add	$v0, $v1, $0	

	addi	$sp, $sp, 12
	lw	$ra, 0($sp)
	addi 	$sp, $sp, 4
	jr	$ra

	invaild:
		addi	$v0, $0, 4
		la	$a0, msg_Invaild
		syscall
		j 	exit	

	exit:
	addi 	$v0, $0, 10
	syscall	

######
to_string:
	lw	$a0, 0($sp)	#day
	lw	$a1, 4($sp)	#month	
	lw	$a2, 8($sp)	#year

	la	$v1, strData
	addi	$t4, $0, 10	

	div	$a0, $t4
	mfhi	$t1	#du
	mflo	$t2	#nguyen
	addi	$t1, $t1, 48
	sb	$t1, 1($v1)
	addi	$t2, $t2, 48
	sb	$t2, 0($v1)

	addi	$t1, $0, 47
	sb	$t1, 2($v1)
	sb	$t1, 5($v1)
	sb	$0, 10($v1)

#month
	div	$a1, $t4
	mfhi	$t1	#du
	mflo	$t2	#nguyen
	addi	$t1, $t1, 48
	sb	$t1, 4($v1)
	addi	$t2, $t2, 48
	sb	$t2, 3($v1)


#year
	
	div	$a2, $t4
	mfhi	$t1	#du
	mflo	$a2	#nguyen
	addi	$t1, $t1, 48
	sb	$t1, 9($v1)

	div	$a2, $t4
	mfhi	$t1	#du
	mflo	$a2	#nguyen
	addi	$t1, $t1, 48
	sb	$t1, 8($v1)


	div	$a2, $t4
	mfhi	$t1	#du
	mflo	$a2	#nguyen
	addi	$t1, $t1, 48
	sb	$t1, 7($v1)
	

	div	$a2, $t4
	mfhi	$t1	#du
	mflo	$a2	#nguyen
	addi	$t1, $t1, 48
	sb	$t1, 6($v1)
#cout
	addi	$v0, $0, 4
	la	$a0, strData
	syscall
	
	jr $ra

#################################################	
checkLogic:	#bool checkLogic(int day, int month, int  year)
	
	
	lw	$a0, 0($sp)	#day
	lw	$a1, 4($sp)	#month	
	lw	$a2, 8($sp)	#year
	
	#a0 - day, a1-month, a2-year
	#check
	slti	$t3, $a0, 1
	bne	$t3, $0, checkLogic_invaild	#day < 1
	slti	$t3, $a1, 1
	bne	$t3, $0, checkLogic_invaild	#month < 1
	slti	$t3, $a2, 1
	bne	$t3, $0, checkLogic_invaild	#year < 1
	slti	$t3, $a1, 13
	beq	$t3, $0, checkLogic_invaild	#month <= 12
	
	addi	$sp, $sp, -12
	sw	$ra, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)

	jal	month_number	#get the mumber of month
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12
	add	$t4, $v0, $0	#$t4 = number of mOnth 
	slt	$t3, $t4, $a0
	bne	$t3, $0, checkLogic_invaild	#day <= numberofmonth

	checkLogic_vaild:	#return true
		addi	$v0, $0, 1
		jr	$ra
	checkLogic_invaild:	#return false
		addi 	$v0, $0, 0
		jr	$ra

# a0: month, a1: year
month_number:
	lw	$a1, 4($sp) #a1= month
	lw	$a2, 8($sp) #a2 = yaer

	addi $t0, $a1, -1
	beq	$t0, $0, cs31 # month = 1
	
	addi $t0, $a1, -3
	beq	$t0, $0, cs31 # month = 3
	
	addi $t0, $a1, -5
	beq	$t0, $0, cs31 # month = 5
	
	addi $t0, $a1, -7
	beq	$t0, $0, cs31 # month = 7
	
	addi $t0, $a1, -8
	beq	$t0, $0, cs31 # month = 8
	
	addi $t0, $a1, -10
	beq	$t0, $0, cs31 # month = 10
	
	addi $t0, $a1, -12
	beq	$t0, $0, cs31 # month = 12

	addi $t0, $a1, -4
	beq	$t0, $0, cs30 # month = 4
	
	addi $t0, $a1, -6
	beq	$t0, $0, cs30 # month = 6
	
	addi $t0, $a1, -9
	beq	$t0, $0, cs30 # month = 9
	
	addi $t0, $a1, -11
	beq	$t0, $0, cs30 # month = 11

	# month = 2
	addi 	$sp, $sp,  -4
	sw 	$ra, 0($sp)
	jal	is_leap
	lw	$ra, 0($sp)
	addi  	$sp, $sp, 4
	
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
		jr	$ra
###################################################################
# a2: year
is_leap:
	addi	$t0, $0, 400
	div	$a2, $t0
	mfhi	$t0
	beq 	$t0, $0, leap_true	#if year % 400 == 0 -> true
	
	addi 	$t0, $0, 4
	div 	$a2, $t0
	mfhi	$t0
	bne	$t0, $0, leap_false	#if year % 4 !=0 -> false
	
	addi $t0, $0, 100
	div 	$a2, $t0
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
# $a0: time1, $a1: time2
GetTime:
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

#######################################################################
# a0: time
WeekDay:
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	jal Day
	sw $v0, 8($sp)
	
	lw $a0, 0($sp)
	jal Month
	sw $v0, 12($sp)
	
	lw $a0, 0($sp)
	jal Year
	add $s2, $v0, $0 # year
	
	lw $ra, 4($sp)
	lw $s0, 8($sp) # day
	lw $s1, 12($sp) # month
	addi $sp, $sp, 16
	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp) # day
	sw $s1, 8($sp) # month
	sw $s2, 12($sp) # year
	
	add $a0, $s2, $0
	jal is_leap
	add $s3, $v0, $0 # is leap
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	
	addi $s4, $s2, -1
	addi $t0, $0, 100
	div $s4, $t0
	mflo $s4 # century
	
	addi $t0, $0, 100
	div $s2, $t0
	mfhi $s2
	add $s0, $s0, $s2
	# now: sum = d + y
	
	addi $t0, $0, 4
	div $s2, $t0
	mflo $s2
	add $s0, $s0, $s2
	# now: sum = d + y + y / 4
	
	add $s0, $s0, $s4
	# now: sum = d + y + y / 4 + c
	
	addi $t0, $0, 2
	slt $t1, $s1, $t0
	mult $s3, $t1
	mflo $s3
	
	addi $t0, $0, 1
	beq $s1, $t0, m0
	
	addi $t0, $0, 2
	beq $s1, $t0, m3
	
	addi $t0, $0, 3
	beq $s1, $t0, m3
	
	addi $t0, $0, 4
	beq $s1, $t0, m6
	
	addi $t0, $0, 5
	beq $s1, $t0, m1
	
	addi $t0, $0, 6
	beq $s1, $t0, m4
	
	addi $t0, $0, 7
	beq $s1, $t0, m6
	
	addi $t0, $0, 8
	beq $s1, $t0, m2
	
	addi $t0, $0, 9
	beq $s1, $t0, m5
	
	addi $t0, $0, 10
	beq $s1, $t0, m0
	
	addi $t0, $0, 11
	beq $s1, $t0, m3
	
	addi $t0, $0, 12
	beq $s1, $t0, m5
	
	m0:
		addi $s1, $0, 0
		j continue_weakday
	m1:
		addi $s1, $0, 1
		j continue_weakday
	m2:
		addi $s1, $0, 2
		j continue_weakday
	m3:
		addi $s1, $0, 3
		j continue_weakday
	m4:
		addi $s1, $0, 4
		j continue_weakday
	m5:
		addi $s1, $0, 5
		j continue_weakday
	m6:
		addi $s1, $0, 6
		j continue_weakday
	
	continue_weakday:
	add $s0, $s0, $s1
	# now: sum = d + m + y + y / 4 + cs
	addi $s0, $s0, 7
	sub $s0, $s0, $s3
	
	addi $t0, $0, 7
	div $s0, $t0
	mfhi $s0
	
	addi $t0, $0, 0
	beq $s0, $t0, WD_Sun
	
	addi $t0, $0, 1
	beq $s0, $t0, WD_Mon
	
	addi $t0, $0, 2
	beq $s0, $t0, WD_Tue
	
	addi $t0, $0, 3
	beq $s0, $t0, WD_Wed
	
	addi $t0, $0, 4
	beq $s0, $t0, WD_Thurs
	
	addi $t0, $0, 5
	beq $s0, $t0, WD_Fri
	
	addi $t0, $0, 6
	beq $s0, $t0, WD_Sat
	
	WD_Sun:
		la $v0, Sun
		jr $ra
	WD_Mon:
		la $v0, Mon
		jr $ra
	WD_Tue:
		la $v0, Tue
		jr $ra
	WD_Wed:
		la $v0, Wed
		jr $ra
	WD_Thurs:
		la $v0, Thurs
		jr $ra
	WD_Fri:
		la $v0, Fri
		jr $ra
	WD_Sat:
		la $v0, Sat
		jr $ra
#####################################################################
# a0: time
# v0: year1
# v1: year2
NeareastLeapYears:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Year
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	add $s0, $v0, $0
	add $s1, $s0, $0
	add $s2, $0, $0 # count
	# s3: v0, $s4: v1
	
	SearchLeapYears:		
		addi $s0, $s0, -1
		addi $s1, $s1, 1

		# find nearest lower
		addi $sp, $sp, -24
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		sw $s4, 20($sp)
		
		add $a0, $s0, $0
		jal is_leap
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		addi $sp, $sp, 24
		
		beq $v0, $0, keep_finding
		addi $t0, $0, 2
		beq $s2, $t0, Found # count >= 2
		
		beq $s2, $0, add_v0_low
		add $s4, $s0, $0
		addi $s2, $s2, 1
		j keep_finding
		add_v0_low:
		add $s3, $s0, $0
		addi $s2, $s2, 1
		
		keep_finding:
		# find nearest upper
		addi $sp, $sp, -24
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		sw $s4, 20($sp)
		
		add $a0, $s1, $0
		jal is_leap
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		addi $sp, $sp, 24
		
		beq $v0, $0, SearchLeapYears
		addi $t0, $0, 2
		beq $s2, $t0, Found # count >= 2
		
		beq $s2, $0, add_v0_upper
		add $s4, $s1, $0
		addi $s2, $s2, 1
		j SearchLeapYears
		add_v0_upper:
		add $s3, $s1, $0
		addi $s2, $s2, 1
		j SearchLeapYears
	Found:
	add $v0, $s3, $0
	add $v1, $s4, $0
	jr $ra
<<<<<<< HEAD
=======

>>>>>>> 03993aa99818e7e28d90e0008bad71a6cd91e429
