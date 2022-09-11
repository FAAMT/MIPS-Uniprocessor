////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  This is a testbench for the           //
//  memory controller.                    //
////////////////////////////////////////////

`include "cpu_ram_if.vh" 
`include "system_if.vh"
`include "cache_control_if.vh"
`include "caches_if.vh"
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;
  
  logic CLK = 0, nRST = 1;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  cpu_ram_if ramif();
  system_if syif();
  caches_if cif0();
  caches_if cif1();
  cache_control_if ccif(cif0, cif1);

  //connect modules
  always_comb 
  begin
    
    
    if(syif.tbCTRL)
    begin
      //Ram Side
      ramif.ramWEN = syif.WEN;
      ramif.ramREN = syif.REN;
      ramif.ramstore = syif.store;
      ramif.ramaddr = syif.addr;
      syif.load = ramif.ramload;
    end
    else begin
      //Ram Side
      ramif.ramWEN = ccif.ramWEN;
      ramif.ramREN = ccif.ramREN;
      ramif.ramstore = ccif.ramstore;
      ramif.ramaddr = ccif.ramaddr;
      //Memory Controller Side
      ccif.ramstate = ramif.ramstate;
      ccif.ramload = ramif.ramload;
    end
    
  end

  // test program
  test PROG(.CLK(CLK), .nRST(nRST), .ccif(ccif));
  // DUT
`ifndef MAPPED
  memory_control DUTA(CLK, nRST, ccif);
  ram DUTB (CLK, nRST, ramif);
`else
  memory_control DUTA(
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\ccif.dstore (ccif.dstore),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.daddr (ccif.daddr),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ramstate(ccif.ramstate),
    .\ccif.ccwrite(ccif.ccwrite),
    .\ccif.cctrans(ccif.cctrans),
    .\ccif.iwait(ccif.iwait),
    .\ccif.dwait(ccif.dwait),
    .\ccif.iload(ccif.iload),
    .\ccif.dload(ccif.dload),
    .\ccif.ramstore(ccif.ramstore),
    .\ccif.ramaddr(ccif.ramaddr),
    .\ccif.ramWEN(ccif.ramWEN),
    .\ccif.ramREN(ccif.ramREN),
    .\ccif.ccwait(ccif.ccwait),
    .\ccif.ccinv(ccif.ccinv),
    .\ccif.ccsnoopaddr(ccif.ccsnoopaddr),
    .\nRST (nRST),
    .\CLK (CLK)
  );

  ram DUTB (
    .\ramif.ramREN (ramif.ramREN),
    .\ramif.ramWEN (ramif.ramWEN),
    .\ramif.memREN (ramif.memREN),
    .\ramif.memWEN (ramif.memWEN),
    .\ramif.memaddr (ramif.memaddr),
    .\ramif.memstore (ramif.memstore),
    .\ramif.ramload (ramif.ramload),
    .\ramif.ramstate(ramif.ramstate),
    .\ramif.ramaddr(ramif.ramaddr),
    .\ramif.ramstore(ramif.ramstore),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
    input logic CLK, 
    output logic nRST,
    cache_control_if.cc ccif
    );
import cpu_types_pkg::*;

task resetdut();
  begin
    nRST = 0;
    #(10)
    nRST = 1;
    ccif.iREN = 0;
    ccif.dREN = 0;
    ccif.dWEN = 0;
    ccif.dstore = 0;
    ccif.iaddr = 0;
    ccif.daddr = 0;
    ccif.ramload = 0;
    ccif.ramstate = FREE;
    ccif.ccwrite = 0;
    ccif.cctrans = 0;
    ccif.iwait = 0;
    ccif.dwait = 0;
    ccif.iload = 0;
    ccif.dload = 0;
    ccif.ramstore = 0;
    ccif.ramaddr = 0;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;
    ccif.ccwait = 0;
    ccif.ccinv = 0;
    ccif.ccsnoopaddr = 0;
    
  end
endtask 

task check_outputs(logic expectation1, word_t expectation2, word_t expectation3);
  begin
    if(expectation1 == ~ccif.dwait[0])begin
      $display("Correct D-Ready value of %d", ~ccif.dwait[0]);
    end
    else begin
      $display("Incorrect D-Ready, it was instead %d", ~ccif.dwait[0]);
    end

    if(expectation2 == ccif.dload[0])begin
      $display("Correct data value of %h", ccif.dload[0]);
    end
    else begin
      $display("Incorrect data, it was instead %h", ccif.dload[0]);
    end

     if(expectation3 == ccif.iload[0])begin
      $display("Correct instruction value of %h", ccif.iload[0]);
    end
    else begin
      $display("Incorrect instruction, it was instead %h", ccif.iload[0]);
    end
  end
endtask 

task automatic dump_memory();
    string filename = "mydumpfile.hex";
    int memfd;

    syif.tbCTRL = 1;
    syif.addr = 0;
    syif.WEN = 0;
    syif.REN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      syif.addr = i << 2;
      syif.REN = 1;
      repeat (4) @(posedge CLK);
      if (syif.load === 0)
        continue;
      values = {8'h04,16'(i),8'h00,syif.load};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),syif.load,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      syif.tbCTRL = 0;
      syif.REN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

initial begin
    $monitor("@%00g CLK= %b ",
    $time, CLK, nRST);
   
   //Test Case 1: Power-On Reset DUT
   $display("Test Case 1: Power-On Reset DUT");
   resetdut();

   #(20)
   check_outputs(0, 32'h0, 32'h0 ); //Default value at location ramaddr -> 0x0000
   #(20)

   //Test Case 2: Data Access
   $display("Test Case 2: Data Read Access (D-Request)");
   resetdut();
   #(20)
   
   //Simulate D-Request for a data read
   cif0.dREN = 1;
   cif0.daddr = 32'h10; //Location 0x000F
   
   //Sample after 2 clock cycles
   #(20);

   //Check that D-Ready is high and the data is secured
   check_outputs(1, 32'h8C230000, 32'h0 ); //ramaddr -> 0x000F
   
   #(20);

   //Simulate D-Request deassertion
   cif0.dREN = 0;
   cif0.daddr = 32'h0000;

   #(20);

   //Confirm that D-Ready is low and the value is retained
   check_outputs(0, 32'h8C230000, 32'h0 );

   //Test Case 3: Data Write Access (D-Request)
   $display("Test Case 3: Data Write Access (D-Request)");
   resetdut();
   #(20)
   
   //Simulate D-Request for a data read
   cif0.dstore = 32'hBACCA;
   cif0.daddr = 32'h10; //Location 0x0004
   cif0.dWEN = 1;
   //Sample after 2 clock cycles
   #(20);

   //Simulate D-Request deassertion
   cif0.dWEN = 0;
   cif0.daddr = 32'h0000;
   cif0.dstore = 0;

  //Test Case 4: Instruction Fetch (I-Request)
   $display("Test Case 4: Instruction Fetch (I-Request)");
   resetdut();
   #(20)
   cif0.iaddr = 32'h8; //Location 0x000F
   cif0.iREN = 1;
   //Sample after 2 clock cycles
   #(20);

   //Confirm that D-Ready is low and the value is retained
   check_outputs(0, 32'h0 , 32'h3C07DEAD);

   #(20);

   //Simulate D-Request deassertion
   cif0.iREN = 0;
   cif0.iaddr = 32'h0000;
   
   #(20);

   //Confirm that D-Ready is low and the value is retained
   check_outputs(0, 32'h0 , 32'h3C07DEAD);

  #(20);

  //Test Case 5: Both D-Request & I-Request
   $display("Test Case 5: Both D-Request & I-Request");
   resetdut();

   #(20);

   //Simulate D-Request deassertion
   cif0.dWEN = 1;
   cif0.iREN = 1;
   cif0.iaddr = 32'h10;
   cif0.daddr = 32'h30; //Location 0x0004
   cif0.dstore = 32'hECE437;
   
   #(20);

   //Confirm that D-Ready is low and the value is retained
   check_outputs(1, 32'h0 , 32'h0);

  #(20);


  dump_memory();

  $finish;
end
endprogram
