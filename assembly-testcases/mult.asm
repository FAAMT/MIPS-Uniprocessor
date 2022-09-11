#---------------------------------------
# Program 1: Multiply
#---------------------------------------

  ori $1, $0, 20
  push $1
  ori $1, $0, 4
  push $1
  jal mult
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

