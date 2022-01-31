/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST =1;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG(.CLK(CLK), .nRST(nRST), .rfif(rfif));
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
    input logic CLK, 
    output logic nRST,
    register_file_if rfif
    );

task resetdut();
  begin
    nRST = 0;
    #(10)
    nRST = 1;
    rfif.rsel1 = 0;
    rfif.rsel2 = 0;
    rfif.wsel = 0;
    rfif.wdat = 0;
    rfif.WEN = 0;
  end
endtask 

task check_outputs(logic [31:0] expectedrdat1, logic [31:0] expectedrdat2);
  begin
    if(expectedrdat1 == rfif.rdat1)begin
      $display("Correct rdat1");
    end
    else begin
      $display("Incorrect rdat1, it was instead %d", expectedrdat1);
      
    end

   if(expectedrdat2 == rfif.rdat2)begin
      $display("Correct rdat2");
    end
    else begin
      $display("Incorrect rdat2, it was instead %d", expectedrdat2);
    end
  end
endtask 

task multiplewrites(arg1, arg2, arg3, arg4, arg5, arg6);
  begin
    #(10)

   rfif.WEN = 1; 
   rfif.wsel = arg1; 
   rfif.wdat = arg2; 
   rfif.rsel1 = arg3;
   rfif.rsel2 = arg4;
   #(20);
   check_outputs(arg5, arg6);
   #(20);
  end
endtask //automatic

initial begin
    $monitor("@%00g CLK= %b nRST= %b rdat1= %0d rdat2= %0d rsel1= %0d rsel2= %0d wsel= %0d wdat= %0d WEN= %0d",
    $time, CLK, nRST, rfif.rdat1, rfif.rdat2, rfif.rsel1, rfif.rsel2, rfif.wsel, rfif.wdat, rfif.WEN);
   
   //Test Case 1: Power-On Reset DUT
   $display("Test Case 1: Power-On Reset DUT");
   resetdut();

   #(20)
   check_outputs(32'd0, 32'd0);
   #(20)

   //Test Case 2: Simple Write
   $display("Test Case 2: Simple Write");
   resetdut();

   #(10)

   rfif.WEN = 1; //Write Enabled
   rfif.wsel = 27; //Register 27
   rfif.wdat = 27; //value = 27
   rfif.rsel1 = 27;
   #(20)
   check_outputs(32'd27, 32'd0);
   #(20)

   //Test Case 3: Erroneous Write
   $display("Test Case 3: Erroneous Write");
   resetdut();

   #(10)

   rfif.WEN = 1; //Write Enabled
   rfif.wsel = 0; //Register 0
   rfif.wdat = 15; //value = 15

   #(20)
   check_outputs(32'd0, 32'd0);
   #(20)


   //Test Case 2: Simple Write
   /*$display("Test Case 4: Multiple Writes");
   resetdut();
   for(int i = 0; i < 32; i++) begin
     multiplewrites(i, 32 - i, i, i+1, 32 - i, 0);
   end*/
   
  $finish;
end
endprogram
