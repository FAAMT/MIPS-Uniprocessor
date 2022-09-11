////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  This is a testbench for the ALU.      //
////////////////////////////////////////////

`include "alu_if.vh"
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST =1;


  always #(PERIOD/2) CLK++;

  alu_if alu ();

  test PROG(.CLK(CLK), .nRST(nRST), .alu(alu));

`ifndef MAPPED
  alu DUT(CLK, nRST, alu);
`else
  alu DUT(
    .\alu.op (alu.op),
    .\alu.opearand1 (alu.operand1),
    .\alu.operand2 (alu.operand2),
    .\alu.result (alu.result),
    .\alu.negative (alu.negative),
    .\alu.zero (alu.zero),
    .\alu.overflow (alu.overflow),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
    input logic CLK, 
    output logic nRST,
    alu_if.alu alu
    );
import cpu_types_pkg::*;

task resetdut();
  begin
    nRST = 0;
    #(10)
    nRST = 1;
    alu.operand1 = 0;
    alu.operand2 = 0;
    
  end
endtask 

task check_output(logic [31:0] expectedresult);
  begin
    if(expectedresult == alu.result)begin
      $display("Correct result of %d", alu.result);
    end
    else begin
      $display("Incorrect rdat1, it was instead %d", alu.result);
      
    end
  end
endtask 

initial begin
    $monitor("@%00g CLK= %b nRST= %b op= %0d operand1= %0d operand2= %0d result= %0d n= %0d o= %0d z= %0d",
    $time, CLK, nRST, alu.op, alu.operand1, alu.operand2, alu.result, alu.negative, alu.overflow, alu.zero);
   
   $display("Test Case 1: Power-On Reset DUT");
   resetdut();

   #(20)
   check_output(32'd0);
   #(20)

   $display("Test Case 2: Test Signed Add/Subtract");
   resetdut();

   #(10)
   alu.op = ALU_ADD;
   alu.operand1 = 32'd1;
   alu.operand2 = 32'd1;
   #(20)
   check_output(32'd2);
   #(20)

   #(10)
   alu.op = ALU_SUB;
   alu.operand1 = 32'd5;
   alu.operand2 = 32'd3;
   #(20)
   check_output(32'd2);
   #(20)

   $display("Test Case 3: Test Logical Shift Left and Right");
   resetdut();

   #(10)
   alu.op = ALU_SLL;
   alu.operand1 = 32'd1;
   alu.operand2 = 32'd5;
   #(20)
   check_output(32'd10);
   #(20)

   #(10)
   alu.op = ALU_SRL;
   alu.operand1 = 32'd1;
   alu.operand2 = 32'd10;
   #(20)
   check_output(32'd5);
   #(20)

   $display("Test Case 4: Test Less Than Signed/Unsigned");
   resetdut();

   #(10)
   alu.op = ALU_SLT;
   alu.operand1 = 32'd5;
   alu.operand2 = 32'd1;
   #(20)
   check_output(32'd0);
   #(20)

   #(10)
   alu.op = ALU_SUB;
   alu.operand1 = 32'd0;
   alu.operand2 = 32'd5;
   alu.op = ALU_SLT;
   alu.operand1 = alu.result;
   alu.operand2 = 32'd1;
   #(20)
   check_output(32'd1);
   #(20)

  #(10)
   alu.op = ALU_SUB;
   alu.operand1 = 32'd0;
   alu.operand2 = 32'd5;
   alu.op = ALU_SLTU;
   alu.operand1 = alu.result;
   alu.operand2 = 32'd1;
   #(20)
   check_output(32'd0);
   #(20)

   $display("Test Case 5: Test Or, Xor, and Nor");
   resetdut();

   #(10)
   alu.op = ALU_OR;
   alu.operand1 = 32'b1100;
   alu.operand2 = 32'b11;
   #(20)
   check_output(32'b1111);
   #(20)

   #(10)
   alu.op = ALU_XOR;
   alu.operand1 = 32'b11011100;
   alu.operand2 = 32'b11001100;
   #(20)
   check_output(32'b10000);
   #(20)

   $display("Test Case 6: Test Flag Conditions");
   resetdut();

   #(10)
   alu.op = ALU_SUB;
   alu.operand1 = 32'd0;
   alu.operand2 = 32'd1;
   #(20)
   #(20)

   #(10)
   alu.op = ALU_ADD;
   alu.operand1 = 32'hffffffff;
   alu.operand2 = 32'h2;
   #(20)

   #(20)


  $finish;
end
endprogram
