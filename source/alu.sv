`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu
(
    input logic CLK, nRST,
    alu_if.alu alu
);
    import cpu_types_pkg::*;

    always_comb begin : ALU
       case (alu.op)
            //ALU_SLL
            ALU_SLL: alu.result = alu.operand2 <<  alu.operand1;

            //ALU_SRL
            ALU_SRL: alu.result = alu.operand2 >> alu.operand1;
            
            //ALU_ADD
            ALU_ADD: alu.result = alu.operand1 + alu.operand2;
            
            //ALU_SUB
            ALU_SUB: alu.result = alu.operand1 - alu.operand2;

            //ALU_AND
            ALU_AND: alu.result = alu.operand1 & alu.operand2;

            //ALU_OR
            ALU_OR: alu.result = alu.operand1 | alu.operand2;

            //ALU_XOR
            ALU_XOR: alu.result = alu.operand1 ^ alu.operand2;

            //ALU_NOR
            ALU_NOR: alu.result = !(alu.operand1 | alu.operand2);

            //ALU_SLT
            ALU_SLT: alu.result = ($signed(alu.operand1) < $signed(alu.operand2)) ? 1 : 0;

            //ALU_SLTU
            ALU_SLTU: alu.result = (alu.operand1 < alu.operand2) ? 1 : 0;

           default: alu.result = 0; 
       endcase 
    end
    
    assign alu.zero = (alu.result == 0) ? 1 : 0;
    assign alu.negative = (alu.result[31]) ? 1 : 0;
    
    always_comb begin
    if(alu.op == ALU_ADD)
    begin
        alu.overflow = ((alu.operand1[31] && alu.operand2[32]) | (alu.operand1[31] ^ alu.operand2[31] && !alu.result[31])) ? 1 : 0;
    end
    else if(alu.op == ALU_SUB)
    begin
        alu.overflow = (alu.operand1[31] < alu.operand2[31]) ? 1 : 0;
    end
    else 
    begin
        alu.overflow = 0;
    end
    end

endmodule