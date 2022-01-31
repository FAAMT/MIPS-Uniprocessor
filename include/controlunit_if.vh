/*
  Fahad Tajiki
  fahadahmaedmurad@gmail.com

  control  unit interface
*/
`ifndef CONTROLUNIT_VH
`define CONTROLUNIT_VH


`include "cpu_types_pkg.vh" //cpu types
`include "cuif_types_pkg.vh"

interface controlunit_if; //interface label
import cpu_types_pkg::*; // import types
import cuif_types_pkg::*; // import types

  word_t imemload; //instruction from memory
  word_t instruction; //instruction mnemonic
  funct_t ALUop; //ALU op code mnemonic
  jctrl Jump; //instruction specific control signal for J, JR, and JAL.
  wctrl RFWdata; //instruction specific control signal for register file input: "wdat" 
  ectrl ext; //instruction specific control signal for extender output
  logic negative, zero, overflow; //input flag conditions
  logic MemRead, MemWrite, Branch, WEN, ALUsrc, RegDst1, RegDst2, halt; //general control signals


  // register file ports
  modport cuif (
    input    imemload, negative, zero, overflow,
    output   instruction, ALUop, Jump, RFWdata, MemRead, MemWrite, Branch, WEN, ALUsrc, RegDst1, RegDst2, ext, halt
  );
  // register file tb
  modport tb (
    input   instruction, ALUop, Jump, RFWdata, MemRead, MemWrite, Branch, WEN, ALUsrc, RegDst1, RegDst2, ext,
    output   imemload, negative, zero, overflow, halt
  );
endinterface

`endif //CONTROLUNIT_VH
