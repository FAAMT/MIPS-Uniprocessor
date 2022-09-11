////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  This is a testbench for the           //
//  control unit.                         //
////////////////////////////////////////////

`include "controlunit_if.vh"
`include "cpu_types_pkg.vh"
`include "cuif_types_pkg.vh"
`timescale 1 ns / 1 ns

module controlunit_tb;
  parameter PERIOD = 10;
  logic CLK = 0, nRST =1;
  always #(PERIOD/2) CLK++;
  controlunit_if cuif ();
  test PROG(.CLK(CLK), .nRST(nRST), .cuif(cuif));
`ifndef MAPPED
  controlunit DUT(CLK, nRST, cuif);
`else
  controlunit DUT(
  .\cuif.imemload(cuif.imemload),
  .\cuif.negative (cuif.negative),
  .\cuif.zero (cuif.zero),
  .\cuif.overflow (cuif.overflow),
  .\cuif.instruction (cuif.instruction),
  .\cuif.ALUop (cuif.ALUop),
  .\cuif.Jump (cuif.Jump),
  .\cuif.RFWdata (cuif.RFW),
  .\cuif.MemRead (cuif.MemRead),
  .\cuif.MemWrite (cuif.MemWrite),
  .\cuif.Branch (cuif.Branch),
  .\cuif.WEN (cuif.WEN),
  .\cuif.ALUsrc (cuif.ALUsrc),
  .\cuif.RegDst1 (cuif.RegDst1),
  .\cuif.RegDst2 (cuif.RegDst2),
  .\cuif.ext (cuif.ext),
  .\cuif.halt (cuif.halt),
  .\nRST (nRST),
  .\CLK (CLK)
  );
`endif
endmodule

program test(
    input logic CLK, 
    output logic nRST,
    controlunit_if.cuif cuif
    );
import cpu_types_pkg::*;
import cuif_types_pkg::*; 

string tb_test_case;

task resetdut();
  begin
    nRST = 0;
    #(10);
    nRST = 1;
    cuif.imemload = {6'b000000, 5'd0, 5'd0, 5'd0, 5'd0, ADD}; 
    cuif.negative = 1'b0;
    cuif.zero = 1'b0;
    cuif.overflow = 1'b0;
    #(10);
  end
endtask 

task inputs(word_t imemload, logic overflow, zero, negative);
  begin
    #(10);
    cuif.imemload = imemload;
    cuif.overflow = overflow;
    cuif.zero = zero;
    cuif.negative = negative;
    #(10);
  end
endtask

task check_ALUop(funct_t expALUop);
  begin
    if(expALUop == cuif.ALUop)begin
     $display("ALUop [CORRECT]");
    end
    else begin
    $display("ALUop [INCORRECT]");
    end
  end
endtask 

task check_Jump(jctrl expJump);
  begin
    if(expJump == cuif.Jump)begin
    $display("Jump [CORRECT]");
    end
    else begin
    $display("Jump [INCORRECT]");
    end
  end
endtask 

task check_RFWdata(wctrl expRFWdata);
  begin
    if(expRFWdata == cuif.RFWdata)begin
		$display("Register File Write Data [CORRECT]");
    end
    else begin
		$display("Register File Write Data [INCORRECT]");
    end
  end
endtask 

task check_MemRead(logic expMemRead);
  begin
    if(expMemRead == cuif.MemRead)begin
		$display("MemRead [CORRECT]");
    end
    else begin
		$display("MemRead [INCORRECT]");
    end
  end
endtask 

task check_MemWrite(logic expMemWrite);
  begin
    if(expMemWrite == cuif.MemWrite)begin
		$display("MemWrite [CORRECT]");
    end
    else begin
		$display("MemWrite [INCORRECT]");
    end
  end
endtask 

task check_Branch(logic expBranch);
  begin
    if(expBranch == cuif.Branch)begin
		$display("Branch [CORRECT]");
    end
    else begin
		$display("Branch [INCORRECT]");
    end
  end
endtask 

task check_ext(ectrl expext);
  begin
    if(expext == cuif.ext)begin
		$display("ext [CORRECT]");
    end
    else begin
		$display("ext [INCORRECT]");
    end
  end
endtask 

task check_WEN(logic expWEN);
  begin
    if(expWEN == cuif.WEN)begin
		$display("WEN [CORRECT]");
    end
    else begin
		$display("WEN [INCORRECT]");
    end
  end
endtask 


task check_ALUsrc(logic expALUsrc);
  begin
    if(expALUsrc == cuif.ALUsrc)begin
		$display("ALUsrc [CORRECT]");
    end
    else begin
		$display("ALUsrc [INCORRECT]");
    end
  end
endtask 


task check_RegDst1(logic expRegDst1);
  begin
    if(expRegDst1 == cuif.RegDst1)begin
   //   $display("RegDst1 [CORRECT]");
    end
    else begin
      $display("RegDst1 [INCORRECT]");
    end
  end
endtask 


task check_RegDst2(logic expRegDst2);
  begin
    if(expRegDst2 == cuif.RegDst2)begin
    //  $display("RegDst2 [CORRECT]");
    end
    else begin
      $display("RegDst2 [INCORRECT]");
    end
  end
endtask

  task check_halt(logic exphalt);
  begin
    if(exphalt == cuif.halt)begin
    //  $display("halt [CORRECT]");
    end
    else begin
      $display("halt [INCORRECT]");
    end
  end
endtask 

initial begin 
   tb_test_case = "Test Case 1: Power-On Reset DUT";
   $display(tb_test_case);
   resetdut();

   check_ALUop(ADD);
   
   check_RegDst1(1);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

   tb_test_case = "Test Case 2: R-Format Instruction (ADD)";
   $display(tb_test_case);
   //reset the module
   resetdut();

   //set the inputs
   inputs({6'b000000, 5'd0, 5'd0, 5'd0, 5'd0, ADD}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(1);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

   tb_test_case = "Test Case 3: R-Format Instruction (AND)";
   $display(tb_test_case);
   //reset the module
   resetdut();

   //set the inputs
   inputs({6'b000000, 5'd0, 5'd0, 5'd0, 5'd0, AND}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(AND);
   
   check_RegDst1(1);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

   tb_test_case = "Test Case 4: R-Format Instruction (JR)";
   $display(tb_test_case);
   //reset the module
   resetdut();

   //set the inputs
   inputs({6'b000000, 5'd0, 5'd0, 5'd0, 5'd0, JR}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(1);
   check_RegDst2(0);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlJR);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

   tb_test_case = "Test Case 5: J-Format Instruction (J)";
   $display(tb_test_case);
   //reset the module
   resetdut();

   //set the inputs
   inputs({J, 26'd0}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(1);
   check_RegDst2(0);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlJ);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

   tb_test_case = "Test Case 6: J-Format Instruction (JAL)";
   $display(tb_test_case);
   //reset the module
   resetdut();

   //set the inputs
   inputs({JAL, 26'd0}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(1);
   check_RegDst2(1);

   check_WEN(1);
   check_RFWdata(ctrlNPC);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlJ);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

   tb_test_case = "Test Case 7: I-Format Instruction (ADDI)";
   $display(tb_test_case);
   //reset the module
   resetdut();

   //set the inputs
   inputs({ADDI, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(ADD);
  
   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(1);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlSIGN);
   check_halt(0);

   tb_test_case = "Test Case 8: I-Format Instruction (XORI)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({XORI, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); 

   //check the outputs
   check_ALUop(XOR);

   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(1);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);


   tb_test_case = "Test Case 9a: I-Format Instruction (BEQ)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({BEQ, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b1, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(SUB);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(1);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

    tb_test_case = "Test Case 9b: I-Format Instruction (BEQ)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({BEQ, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(SUB);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);


   tb_test_case = "Test Case 10a: I-Format Instruction (BNE)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({BNE, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b1, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(SUB);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

    tb_test_case = "Test Case 10b: I-Format Instruction (BNE)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({BNE, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(SUB);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(0);

   check_Branch(1);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlLSB);
   check_halt(0);

  tb_test_case = "Test Case 11: I-Format Instruction (LUI)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({LUI, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlIMM);

   check_ALUsrc(0);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlMSB);
   check_halt(0);

  
  tb_test_case = "Test Case 12: I-Format Instruction (LW)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({LW, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlMEMDATA);

   check_ALUsrc(1);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(1);
   check_MemWrite(0);

   check_ext(ctrlSIGN);
   check_halt(0);

    tb_test_case = "Test Case 13: I-Format Instruction (SW)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({SW, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(ADD);
   
   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(0);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(1);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(1);

   check_ext(ctrlSIGN);
   check_halt(0);


    tb_test_case = "Test Case 14a: I-Format Instruction (SLTI)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({SLTI, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(SLT);
   
   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(1);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlSIGN);
   check_halt(0);

    tb_test_case = "Test Case 14b: I-Format Instruction (SLTIU)";
   $display(tb_test_case);
   //reset the module
   resetdut();

  //set the inputs
   inputs({SLTIU, 5'd0, 5'd0, 16'd0}, 1'b0, 1'b0, 1'b0); //zero flag set

   //check the outputs
   check_ALUop(SLTU);
   
   check_RegDst1(0);
   check_RegDst2(0);

   check_WEN(1);
   check_RFWdata(ctrlALURESULT);

   check_ALUsrc(1);

   check_Branch(0);
   check_Jump(ctrlDefault);

   check_MemRead(0);
   check_MemWrite(0);

   check_ext(ctrlSIGN);
   check_halt(0);


  $finish;
end
endprogram
