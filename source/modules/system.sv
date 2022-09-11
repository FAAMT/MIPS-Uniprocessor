////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  This is the source code for the       //
//  overall system.                       //
////////////////////////////////////////////

`include "system_if.vh"
`include "cpu_types_pkg.vh"

module system (input logic CLK, nRST, system_if.sys syif);

  logic halt;

  // clock division
  parameter CLKDIV = 2;
  logic CPUCLK;
  logic [3:0] count;

  always_ff @(posedge CLK, negedge nRST)
  begin
    if (!nRST)
    begin
      count <= 0;
      CPUCLK <= 0;
    end
    else if (count == CLKDIV-2)
    begin
      count <= 0;
      CPUCLK <= ~CPUCLK;
    end
    else
    begin
      count <= count + 1;
    end
  end

  // interface
  cpu_ram_if                            prif ();

  // processor
  singlecycle #(.PC0('h0))              CPU (CPUCLK, nRST, halt, prif);

  // memory
  ram                                   RAM (CLK, nRST, prif);

  // interface connections
  assign syif.halt = halt;
  assign syif.load = prif.ramload;

  // who has ram control
  assign prif.ramWEN = (syif.tbCTRL) ? syif.WEN : prif.memWEN;
  assign prif.ramREN = (syif.tbCTRL) ? syif.REN : prif.memREN;
  assign prif.ramaddr = (syif.tbCTRL) ? syif.addr : prif.memaddr;
  assign prif.ramstore = (syif.tbCTRL) ? syif.store : prif.memstore;

endmodule
