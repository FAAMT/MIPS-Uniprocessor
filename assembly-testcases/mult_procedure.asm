#---------------------------------------
# Program 1: Multiply Procedure
#---------------------------------------

main:
  ori $29, $29, 0xfffc //set the stack pointer

  addi $29, $29, -4
  ori $1, $0, 2 //operand1
  sw $1, 0($29) 
 
  addi $29, $29, -4
  ori $1, $0, 3 //operand2 
  sw $1, 0($29)
  
  addi $29, $29, -4
  ori $1, $0, 4 //operand3
  sw $1, 0($29)

  ori $1, $0, 5
  push $1

  jal mult
  lw $9, 0($29)
  jal mult
  lw $10, 0($29)
  
  halt

mult:
  //Parameters
  pop $2 //X
  pop $3 //Y
  ori $4, $0, 32 //N
  ori $5, $0, 0 //A

step1:  
  ori $1, $0, 0x1 //r1 = 0x1
  and $1, $1, $3 // r1 = 0x1 & Y
  bne $1, $0, step2 //r1 != 0
  j step3

step2:
  add $5, $5, $2 //A = A + B
  j step3

step3:
  ori $1, $0, 1 //r1 = 1
  sllv $2, $1, $2 // r2 = r2 << 1
  srlv $3, $1, $3 // r3 = r3 >> 1
  sub $4, $4, $1 //r4 = r4 - 1
  bne $4, $0, step1
  push $5 //Put the result on the stack
  jr $31 


#mult:
#  lw  $3, 0($29) //first retrieve operand2
#  addi $29, $29, 4
#
#  lw  $2, 0($29) //then retrieve operand1
#  addi $29, $29, 4
#
#  addi $4, $0, 0 //
#  addi $5, $0, 0 //i=0
#
#forcond:
#  slt $6, $5, $3// i < operand2
#  bne $6, $0, loop 
#  j end //else end
#
#loop:
#  add $4, $4, $2 //temp += $2
#  addi $5, $5, 1 //i++
#  j forcond 
#
#end:
#  //store in the stack 
#  addi $29, $29, -4 
#  sw $4, 0($29)
#  jr $31

