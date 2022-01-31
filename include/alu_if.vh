/*
  Fahad Tajiki
  fahadahmaedmurad@gmail.com

  arithemetic logic unit interface
*/
`ifndef ALU_VH
`define ALU_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t op; //opcode
  logic negative, zero, overflow; //flag conditions
  word_t    operand1, operand2, result; //input a, b, and output

  // register file ports
  modport alu (
    input   op, operand1, operand2,
    output  result, negative, zero, overflow
  );
  // register file tb
  modport tb (
    input   result, negative, zero, overflow,
    output  op, operand1, operand2
  );
endinterface

`endif //ALU_VH
