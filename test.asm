
.data
	strData: .space 11
	newLine: .asciiz "\n"
	slash:	.byte	'/'
	
	msg_Invaild: .asciiz "The date inputed is invaild"
	msg_Vaild: .asciiz "The date inputed is Vaild"
.text
##################################################################################################
inputDate:
	#read in string
	addi	$v0, $0, 8
	la	$a0, strData
	addi	$a1, $0, 11
	syscall
	
	# $s0 stores strData
	add	$s0, $a0, $0

	jal	checkSyntax
	add	$t0, $v0, $0	#if $t0 = 0 -> syntax error
	beq	$t0, $0, invaild

	#checklogic
	#jal	checkLogic
	#add	$t0, $v0, $0	#if $t0 = 0 -> syntax error
	#beq	$t0, $0, invaild


	#vaild:
	addi	$v0, $0, 1	#return true
	j	exit

	invaild:
		addi	$v0, $0, 4
		la	$a0, msg_Invaild
		syscall

		addi	$v0, $0, 1	#return false
		j 	exit
	#jr	$ra
	
	exit:
	addi 	$v0, $0, 10
	syscall	

#################################################
checkSyntax:	#bool check(string str)

	addi	$t4, $0, 47	# slash '/'
	addi	$t5, $0, 57	# character '9'

	add	$t0, $0, $0 	#	i=0

        loop_st:
	slti	$t1, $t0, 10	#	if i < 10 -> t1 = 1
	beq	$t1, $0, out_st	#	if i >= 10 -> break
	add	$t1, $a0, $t0	#	t1 = a0 + t0 <=> t1 = str+i
	lb	$t2, 0($t1)	#	t2 = str[i]
	
	addi	$t1, $t2, -10	#	t1 = (str[i] == '\n')
	beq	$t1, $0, out_st
	

	#check here
	slt	$t1, $t2, $t4	#	t1 = (str[i] < 47)
	bne	$t1, $0, end_st
	slt	$t1, $t5, $t2	#	t1 = (57 < str[i])
	bne	$t1, $0, end_st	#	if t1==1 -> return false
	
	addi	$t0, $t0, 1	# 	i++
	j	loop_st

	out_st:	#return true
		addi	$v0, $0, 1
		jr	$ra
	end_st:	#return false
		addi 	$v0, $0, 0
		jr	$ra

#################################################	
checkLogic:	#bool checkLogic(string str)

		

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
