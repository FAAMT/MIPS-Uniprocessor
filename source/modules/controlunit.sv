////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  The purpose of the control unit is to //
//  communicate the control signals across//
//  the datapathmodules to achieve        //
//  efficient single cycle computation of //
//  the MIPs instruction set.             // 
////////////////////////////////////////////

`include "cpu_types_pkg.vh"
`include "cuif_types_pkg.vh"
`include "controlunit_if.vh"

module controlunit
(
    input logic CLK, nRST,
   controlunit_if.cuif cuif
);
    import cpu_types_pkg::*;
    import cuif_types_pkg::*; // import types

assign cuif.instruction = cuif.imemload; //connect instruction to the imemload signal

//Control Unit Main Logic
always_comb begin
    cuif.halt = 0; //Do not halt
   
    casez(opcode_t'(cuif.instruction[31:26])) //sort into R-format, I-format, and J-format.
        //R-format instructions
        6'b000000: 
        begin
            if(funct_t'(cuif.instruction[5:0]) == JR) //Jump Register Instruction Sequence
            begin
                cuif.ALUop = ADD; //ALU Operation Sequence

                cuif.RegDst1 = 1; //Rd is the destination register
                cuif.RegDst2 = 0; //

                cuif.WEN = 0; //Don't write to register file
                cuif.RFWdata = ctrlALURESULT; // from memory
                
                cuif.ALUsrc = 0; //RF output of rdat2 -> ALU input of operand

                cuif.Branch = 0; //PC <= R[rs]
                cuif.Jump = ctrlJR;

                cuif.MemRead = 0; //No interaction with RAM
                cuif.MemWrite = 0;//

                cuif.ext = ctrlLSB; //Zero Extension LSB
            end
            else begin
                cuif.ALUop = funct_t'(cuif.instruction[5:0]); //ALU Operation Sequence

                cuif.RegDst1 = 1; //Rd is the destination register
                cuif.RegDst2 = 0; //

                cuif.WEN = 1; //Allow writes to register file
                cuif.RFWdata = ctrlALURESULT; // from ALU
                
                cuif.ALUsrc = 0; //RF output of rdat2 -> ALU input of operand2

                cuif.Branch = 0; //PC <= npc
                cuif.Jump = ctrlDefault; //

                cuif.MemRead = 0; //No interaction with RAM
                cuif.MemWrite = 0;//

                cuif.ext = ctrlLSB; //Zero Extension LSB
            end
            
        end

        //J-format instructions
        6'b00001?: //Jump And Link or Jump Instruction Sequence 
        begin
            cuif.ALUop = ADD; //ALU Operation Sequence

            cuif.RegDst1 = 1; //Rd is the destination register
            cuif.RegDst2 = 0; //

            cuif.WEN = 0; //Don't write to register file
            cuif.RFWdata = ctrlALURESULT; // from memory
                
            cuif.ALUsrc = 0; //RF output of rdat2 -> ALU input of operand

            cuif.Branch = 0; 
            cuif.Jump = ctrlJ; //PC <= JumpAddr

            cuif.MemRead = 0; //No interaction with RAM
            cuif.MemWrite = 0;//

            cuif.ext = ctrlLSB; //Zero Extension LSB
           

            if(cuif.imemload[26])begin 
                cuif.WEN = 1; //Don't write to register file
                cuif.RegDst2 = 1; //RF input of wsel -> 5'd31
                cuif.RFWdata = ctrlNPC; //Reg[31] <= npc
            end
        end

        //I-format instructions
        default: 
        begin
                case(cuif.instruction[31:26])
                    BEQ: //PC <= (R[rs] == R[rt])? npc+BranchAddr : npc;    
                    begin
                        cuif.ALUop = SUB; //R[rs] == R[rt] to set off zero flag

                        cuif.WEN = 0; //Don't write to register file
                        cuif.RFWdata = ctrlALURESULT; // from memory

                        cuif.ALUsrc = 0; //RF output of rdat2 -> ALU input of operand

                        cuif.Jump = ctrlDefault; //PC <= JumpAddr

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlLSB; //Zero Extension LSB

                        if(cuif.zero)
                        begin
                             cuif.Branch = 1; //PC <= npc+BranchAddr
                        end
                        else
                        begin
                             cuif.Branch = 0; //PC <= npc
                        end
                    end

                    BNE: //PC <= (R[rs] != R[rt])? npc+BranchAddr : npc;    
                    begin
                        cuif.ALUop = SUB; //R[rs] == R[rt] to set off zero flag

                        cuif.WEN = 0; //Don't write to register file
                        cuif.RFWdata = ctrlALURESULT; // from memory

                        cuif.ALUsrc = 0; //RF output of rdat2 -> ALU input of operand2

                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlLSB; //Zero Extension LSB

                        if(!cuif.zero)
                        begin
                             cuif.Branch = 1; //PC <= npc+BranchAddr
                        end
                        else
                        begin
                             cuif.Branch = 0; //PC <= npc
                        end
                    end

                    ADDI: //R[rt] <= R[rs] + SignExtImm
                    begin
                        cuif.ALUop = ADD; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlSIGN; //Sign Extension
                    end

                    ADDIU: //R[rt] <= R[rs] + SignExtImm (unchecked overflow)
                    begin
                        cuif.ALUop = ADDU; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlSIGN; //Sign Extension
                    end

                    SLTI:  //R[rt] <= (R[rs] < SignExtImm) ? 1 : 0 
                    begin
                        cuif.ALUop = SLT; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlSIGN; //Sign Extension
                    end

                    SLTIU:  //R[rt] <= (R[rs] < SignExtImm) ? 1 : 0 
                    begin
                        cuif.ALUop = SLTU; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlSIGN; //Sign Extension
                    end

                    ANDI:  //R[rt] <= R[rs] & ZeroExtImm
                    begin
                        cuif.ALUop = AND; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlLSB; //Zero Extension LSB
                    end

                    ORI:   //R[rt] <= R[rs] OR ZeroExtImm
                    begin
                        cuif.ALUop = OR; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlLSB; //Zero Extension LSB
                    end

                    XORI:  //R[rt] <= R[rs] XOR ZeroExtImm
                    begin
                        cuif.ALUop = XOR; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlALURESULT; // from ALU
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlLSB; //Zero Extension LSB
                    end

                    LUI:   //R[rt] <= {imm,16b'0}
                    begin
                        cuif.ALUop = ADD; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlIMM; // from ALU
                        
                        cuif.ALUsrc = 0; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlMSB; //Zero Extension MSB
                    end

                    LW:   //R[rt] <= M[R[rs] + SignExtImm]
                    begin
                        cuif.ALUop = ADD; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 1; //Allow writes to register file
                        cuif.RFWdata = ctrlMEMDATA; // from memory
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 1; //Read from RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlSIGN; //Sign Extension 
                    end
            
                    SW:   //M[R[rs] + SignExtImm] <= R[rt]
                    begin
                        cuif.ALUop = ADD; //ALU Operation Sequence

                        cuif.RegDst1 = 0; //Rt is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 0; //Don't write to register file
                        cuif.RFWdata = ctrlALURESULT; // from memory
                        
                        cuif.ALUsrc = 1; //Extended immediate output -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //Write to RAM
                        cuif.MemWrite = 1;//

                        cuif.ext = ctrlSIGN; //Sign Extension 
                    end

                    HALT: 
                    begin
                        cuif.halt = 1; //halt propgram
                    end 

                    default:
                    begin
                        cuif.ALUop = ADD; //ALU Operation Sequence

                        cuif.RegDst1 = 1; //Rd is the destination register
                        cuif.RegDst2 = 0; //

                        cuif.WEN = 0; //Don't write to register file
                        cuif.RFWdata = ctrlALURESULT; // from memory
                        
                        cuif.ALUsrc = 0; //RF output of rdat2 -> ALU input of operand2

                        cuif.Branch = 0; //PC <= npc
                        cuif.Jump = ctrlDefault; //

                        cuif.MemRead = 0; //No interaction with RAM
                        cuif.MemWrite = 0;//

                        cuif.ext = ctrlLSB; //Zero Extension LSB
                    end
                endcase
            end
    endcase
end
endmodule