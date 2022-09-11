#------------------------------------------------------------------
# Halt Instruction (ALU) Test Program
#------------------------------------------------------------------

initTest:
    //some instructions
    //
    nop

main:
    //some instructions
    //
    nop

body:
    //some instructions
    //
    nop

end:
    ori $1, $0, 0xDEF0
    sw $1, 88($0)
    halt
    //end of program
fail:
    //if code reaches here cause loop
    ori $1, $0, 0xFFFFFF
    sw $1, 88($0)
    halt

    
