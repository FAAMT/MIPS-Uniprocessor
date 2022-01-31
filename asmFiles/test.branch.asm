#------------------------------------------------------------------
# Branch Instruction (ALU) Test Program
#------------------------------------------------------------------
org 0x00

initTest1:
    ori $1, $0, 27
    ori $2, $0, 2

BranchEqualTestFailCondition:
    beq $1, $2, fail
    ori $1, $0, 0xDEF0
    sw $1, 204($0)

passed1: //if it passed this point test condition works

initTest2:
    ori $1, $0, 5
    ori $2, $0, 5

BranchEqualTestPassCondition:
    beq $1, $2, passed2

fail2:
    j fail

passed4: //if it passed this point test condition works
    ori $1, $0, 0xDEF3
    sw $1, 216($0)
    j end

passed2: //if it passed this point test condition works
    ori $1, $0, 0xDEF1
    sw $1, 208($0)

initTest3:
    ori $1, $0, 5
    ori $2, $0, 5

BranchNotEqualTestFailCondition:
    bne $1, $2, fail

passed3: //if it passed this point test condition works
    ori $1, $0, 0xDEF2
    sw $1, 212($0)

initTest4:
    ori $1, $0, 51
    ori $2, $0, 87

BranchNotEqualTestPassCondition:
    bne $1, $2, passed4

fail3:
    j fail

end:
    halt //stop here


fail:
    //if code reaches here cause loop
    ori $1, $0, 0xFFFFFFF
    sw $1, 200($0)
    halt
    
