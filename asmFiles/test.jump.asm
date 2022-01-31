#------------------------------------------------------------------
# Jump Instruction (ALU) Test Program
#------------------------------------------------------------------

initTest:
    //some instructions
    ori $1, $0, 0xDEF0
    sw $1, 120($0)
    j function1
    ori $1, $0, 0xFFFFFF
    sw $1, 120($0)

function1:
    //some instructions
    //
    ori $1, $0, 0xDEF1
    sw $1, 124($0)
    j function2
    ori $1, $0, 0xFFFFFF
    sw $1, 124($0)

function2:
    //some instructions
    //
    ori $1, $0, 0xDEF2
    sw $1, 128($0)
    j end
    ori $1, $0, 0xFFFFFF
    sw $1, 128($0)

end:
    //end of program
    halt


