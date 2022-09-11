////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  The purpose of the datapath, which is // 
//  responsible for the fetch, decode,    //
//  execute, memory, and writeback stages.//
////////////////////////////////////////////

// data path interface
  `include "datapath_cache_if.vh"
  `include "controlunit_if.vh"
  `include "requestunit_if.vh"
  `include "register_file_if.vh"
  `include "alu_if.vh"
  
  // alu op, mips op, and instruction type
  `include "cpu_types_pkg.vh"
  `include "cuif_types_pkg.vh"
  
  module datapath (
    input logic CLK, nRST,
    datapath_cache_if.dp dpif
  );
    //interfaces
    controlunit_if cuif();
    alu_if alu ();
    register_file_if rfif ();
    requestunit_if ruif();
  
    // import types
    import cpu_types_pkg::*;
    import cuif_types_pkg::*;
  
    // PC Init
    parameter PC_INIT = 0;
    word_t PC, NPC;
  
  
    //Extender Internals
    word_t extOut;
  
    //Control Unit Instantion
    controlunit                       CU (CLK, nRST, cuif);
  
    //ALU Instantiation
    alu                               ALU (CLK, nRST, alu);
  
    //Register File Instantiation
    register_file                     RF (CLK, nRST, rfif);
  
    //Request Unit Instantiation
    requestunit                       RU (CLK, nRST, ruif);
  
  
    //CU I/O Setup
    assign cuif.imemload = dpif.imemload; 
    assign cuif.overflow = alu.overflow;
    assign cuif.zero = alu.zero;
    assign cuif.negative = alu.negative;
    assign dpif.halt = cuif.halt;
    assign cuif.iReady = dpif.ihit;
    assign cuif.dReady = dpif.dhit;
  
  
  //Extender Logic
    always_comb
    begin
      case(cuif.ext)
  
        ctrlSIGN:
        begin
          extOut = { {16{cuif.instruction[15]}} , cuif.instruction[15:0] };
        end
  
        ctrlMSB:
        begin
          extOut = {cuif.instruction[15:0], 16'd0};
        end
  
        ctrlLSB:
        begin
          extOut = {16'd0, cuif.instruction[15:0]};
        end
  
        default:
        begin
          extOut = {16'd0, cuif.instruction[15:0]};
        end
      endcase
    end
  
    //Program Counter Logic
    always_ff @ (posedge CLK, negedge nRST)
    begin
      if(!nRST)
      begin
        PC <= PC_INIT;
      end
      else 
      begin
          if(dpif.ihit && !dpif.halt)
          begin
            if((opcode_t'(cuif.instruction[15:0]) != LW) && (opcode_t'(cuif.instruction[15:0]) != SW))
            begin
              PC <= NPC;
            end
            else if(dpif.ihit | dpif.dhit)
            begin
              PC <= NPC;
            end
          end
      end
    end
  
    always_comb 
    begin
      case(cuif.Jump)
  
      ctrlJR:
      begin
        NPC = rfif.rdat1; //NPC = R[rs]
      end
  
      ctrlJ:
      begin
        NPC = (cuif.instruction[25:0] << 2); // NPC = JumpAddr (label * 4)
      end
  
      ctrlDefault:
      begin
        if(cuif.Branch)
        begin
          NPC = PC + 4 + (extOut << 2); //NPC = PC + 4 + BranchAddr (label * 4)
        end
        else 
        begin
          NPC = PC + 4; //NPC = PC + 4
        end
      end
  
      default:
      begin
        NPC = PC + 4; //NPC = PC + 4  
      end
      endcase
    end
  
   ////PC I/O Setup
    assign dpif.imemaddr = PC;
   //ALU I/O Setup
   assign alu.operand1 = rfif.rdat1;
   assign alu.operand2 = (cuif.ALUsrc) ? extOut: rfif.rdat2;
   assign dpif.dmemaddr = (dpif.ihit) ? alu.result : dpif.dmemaddr;
   //Register File I/O Setup
   assign dpif.dmemstore = (dpif.ihit) ? rfif.rdat2 : dpif.dmemstore;
   assign rfif.WEN = (dpif.ihit | dpif.dhit) ? cuif.WEN : 0;
   assign rfif.rsel1 = cuif.instruction[25:21];
   assign rfif.rsel2 = cuif.instruction[20:16];
   //Request Unit I/O Setup
   assign ruif.ihit = dpif.ihit;
   assign ruif.dhit = dpif.dhit;
   assign ruif.MemRead = cuif.MemRead;
   assign ruif.MemWrite = cuif.MemWrite;
   assign dpif.dmemWEN = ruif.dmemWEN;
   assign dpif.dmemREN = ruif.dmemREN;
   assign dpif.imemREN = ruif.imemREN;
  
  
    //ALU Control Logic
    always_comb 
    begin 
      case(cuif.ALUop)
      
      SLLV:
      begin
        alu.op = ALU_SLL;
      end
  
      SRLV:
      begin
        alu.op = ALU_SRL;
      end
  
      JR:
      begin
        alu.op = ALU_ADD;
      end
  
      ADD:
      begin
        alu.op = ALU_ADD;
      end
  
      ADDU:
      begin
        alu.op = ALU_ADD;
      end
  
      AND:
      begin
        alu.op = ALU_AND;
      end
  
      SUB:
      begin
        alu.op = ALU_SUB;
      end
  
      SUBU:
      begin
        alu.op = ALU_SUB;
      end
  
      OR:
      begin
        alu.op = ALU_OR;
      end
  
      XOR:
      begin
        alu.op = ALU_XOR;
      end
  
      NOR:
      begin
        alu.op = ALU_NOR;
      end
  
      SLT:
      begin
        alu.op = ALU_SLT;
      end
  
      SLTU:
      begin
        alu.op = ALU_SLTU;
      end
      endcase
    end
  
    always_comb 
    begin
      //wsel input
      if(cuif.RegDst2)
        begin
          rfif.wsel = 5'd31; //R[31] -> Rd
        end
      else
        begin
          if(cuif.RegDst1)
            begin
              rfif.wsel = cuif.instruction[15:11];
            end
          else
            begin
              rfif.wsel = cuif.instruction[20:16];
            end
        end
      //wdat input
      case(cuif.RFWdata)
      ctrlIMM:
      begin
        rfif.wdat = extOut;
      end
  
      ctrlNPC:
      begin
        rfif.wdat = PC + 4;
      end
  
      ctrlMEMDATA:
      begin
        rfif.wdat = dpif.dmemload;
      end
  
      ctrlALURESULT:
      begin
        rfif.wdat = alu.result;
      end
  
      default:
      begin
        rfif.wdat = alu.result;
      end
      endcase
    end
  
  endmodule