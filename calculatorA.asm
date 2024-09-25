
.text
MAIN:
	
    	lui s1,0xFFFFF
    	lw s0,0x70(s1)          # Read switches
    	sw s0,0x60(s1)		# Write LED
    	
    	andi x10,s0,0x0ff	#x10: numberB
    	srai s0,s0,8
	andi x11,s0,0x0ff	#x11: numberA
    	srai s0,s0,8
	andi x12,s0,0x0ff
	srai x12,x12,5		#x12: option
	
	#addi x10,x0,1
	#addi x11,x0,0x99
	#addi x12,x0,3
	
	add x13,x0,x0
	
	add x18,x0,x0
	beq x12,x18,RST
	addi x18,x18,1
	beq x12,x18,ADD
	addi x18,x18,1
	beq x12,x18,SUB
	addi x18,x18,1
	beq x12,x18,MUL_FAC
	addi x18,x18,1
	beq x12,x18,DIV_FAC
	addi x18,x18,1
	beq x12,x18,RAN
	
	RST:
		add x13,x0,x0
		jal x0,EXIT
		
	ADD:
		andi t0,x11,0xf
		andi t1,x10,0xf
		add t2,t1,t0
		addi t3,x0,10
		blt t2,t3,NO_PLUS
		sub t2,t2,t3
		addi x10,x10,0x10
		NO_PLUS:
		add x13,x0,t2
		srai t0,x11,4
		srai t1,x10,4
		add t2,t0,t1
		slli t2,t2,4
		add x13,x13,t2
		jal x0,EXIT
		
	SUB:
		bge x10,x11,DO_SUB
		add t0,x10,x0
		add x10,x11,x0
		add x11,x0,t0
		DO_SUB:
		andi t1,x11,0xf
		andi t0,x10,0xf
		srai t4,x11,4
		srai t3,x10,4
		bge t0,t1,NO_SUB
		addi t0,t0,10
		addi t3,t3,-1
		NO_SUB:
		sub t2,t0,t1
		add x13,x0,t2
		sub t2,t3,t4
		slli t2,t2,4
		add x13,x13,t2
		jal x0,EXIT
		
	MUL_FAC:
		#slli x11,x11,12
		#sll x13,x11,x10
		add t0,x0,x10
		add t1,x0,x11
		andi t2,t1,0xF0	# numA 整数部分
		srli t2,t2,4
		andi t3,t1,0xF	# numA 小数部分
		LOOP:
			beq t0,x0,DONE
			slli,t2,t2,1
			slli,t3,t3,1
			addi t5,x0,10
			blt t3,t5,SKIP
			sub t3,t3,t5
			addi t2,t2,1
			SKIP:
			addi t0,t0,-1
			jal x0,LOOP
		DONE:
		slli x13,t2,4
		add x13,x13,t3
		jal x0,EXIT
		
		
		
	DIV_FAC:
		#slli x11,x11,12
		#sra x13,x11,x10
		add t0,x0,x10
		andi t1,x11,0x0f
		srai t2,x11,4
		LOOP1:
			beq t0,x0,DONE1
			srai t1,t1,1
			andi t3,t2,0x01
			beq t3,x0,SKIP1
			addi t1,t1,5
			SKIP1:
			srai t2,t2,1
			addi t0,t0,-1
			jal x0,LOOP1
		DONE1:
		slli x13,t2,4
		add x13,x13,t1
		jal x0,EXIT
		
	RAN:
		add t0,x0,x11
		slli t0,t0,8
		add t0,t0,x10
		slli t0,t0,8
		add t0,t0,x11
		slli t0,t0,8
		add t0,t0,x10
		add t1,x0,x0	#t1:cnt
		lui t2,0x00989
		addi t2,t2,0x680
		#li t2,10000000	#t2--10000000: higher_bound
    		sw   t0, 0x00(s1)           # Write 7-seg LEDs
		addi t3 x0,5	#t3--5: generate_random_number
		LOOP5:
			bne x12,t3,DONE5
			add t1,x0,x0
			LOOP6:
				beq t1,t2,DONE6
				addi t1,t1,1
				jal x0,LOOP6
			DONE6:
			add t4,t0,x0
			add t5,t0,x0
			srai t4,t4,1
			xor t5,t5,t4
			srai t4,t4,20
			xor t5,t5,t4
			srai t4,t4,10
			xor t5,t5,t4
			andi t5,t5,0x01
			slli t0,t0,1
			add t0,t0,t5
			
    			sw   t0, 0x00(s1)           # Write 7-seg LEDs
			
			jal x0,LOOP5
		DONE5:
		jal x0,EXIT2
		
	EXIT:
		#decimal:
		andi x20,x13,0x0f
		#integer:
		addi t0,x0,1000
		addi t1,x0,100
		addi t2,x0,10
		srai x18,x13,4
		add x19,x0,x0
		bge x18,t0,BE_1000
		bge x18,t1,BE_100
		bge x18,t2,BE_10
		blt x18,t2,BE_1
		BE_1000:
		LOOP2:
			blt x18,t0,DONE2
			sub x18,x18,t0
			addi x19,x19,0x1
			jal x0,LOOP2
		DONE2:
		slli x19,x19,12
		BE_100:
		LOOP3:
			blt x18,t1,DONE3
			sub x18,x18,t1
			addi x19,x19,0x100
			jal x0,LOOP3
		DONE3:
		BE_10:
		LOOP4:
			blt x18,t2,DONE4
			sub x18,x18,t2
			addi x19,x19,0x10
			jal x0,LOOP4
		DONE4:
		BE_1:
		add x19,x19,x18
		slli x21,x19,16
		add x21,x21,x20
		
    		sw   x21, 0x00(s1)           # Write 7-seg LEDs
		
	EXIT2:
			
			
		
