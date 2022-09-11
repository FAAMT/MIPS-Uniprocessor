#---------------------------------------
# Program 1: Multiply Procedure
#---------------------------------------

main:
  ori $29, $29, 0xfffc #set the stack pointer
  
  ori $13, $0, 25 //r13 -> CurrentDay

 ori $7, $0, 12 //r7 -> CurrentMonth
 ori $1, $0, 1
 sub $1, $7, $1 //CurrentMonth-1
 push $1
 
 ori $1, $0, 30
 push $1
 jal mult //30*(CurrentMonth-1)

 pop $8 //r8 = 30*(CurrentMonth-1)
 add $9, $13, $8 //r9 = CurrentDay + 30*(CurrentMonth-1)
 
 ori $1, $0, 365
 push $1

 ori $1, $0, 2000
 ori $10, $0, 2021 //r10 = CurrentYear
 sub $14, $10, $1 //CurrentYear - 2000
 push $14
 jal mult //r11 -> 365*(CurrentYear - 2000)
 pop $11
 add $12, $9, $11 //CurrentDay + 30*(CurrentMonth-1) + 365*(CurrentYear - 2000)
 
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

