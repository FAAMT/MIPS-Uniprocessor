////////////////////////////////////////////
// Created:     Jan-May 2022              //
// Author:      Fahad Tajiki              //
// Email:       ftajiki@purdue.edu        //
//                                        // 
//  This it the memory controller.        // 
////////////////////////////////////////////

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  always_comb begin

    //Arbitration Procedure

    //Default Settings
    ccif.dwait[0] = 1; //"D-ready"
    ccif.iwait[0] = 1; //"I-ready"

    ccif.ramREN = 0; 
    ccif.ramWEN = 0; 

    if(ccif.dREN[0]) //D-Access R Operation
    begin
      ccif.ramREN = 1; //Assert RAM Read-Only Enable
      ccif.ramaddr = ccif.daddr[0]; //Pass through the data address
      
      if(ccif.ramstate == ACCESS)begin
         ccif.dload[0] = ccif.ramload; //Data is available
         ccif.dwait[0] = 0; //"D-ready" is now asserted
      end
    end

    else if(ccif.dWEN[0]) //D-Access W Operation
    begin
      ccif.ramWEN = 1;  //Assert RAM Write Enable
      ccif.ramaddr = ccif.daddr[0]; //Pass through the data address

      if(ccif.ramstate == ACCESS)begin
         ccif.ramstore = ccif.dstore[0];
         ccif.dwait = 0; //"D-ready" is now asserted
      end
    end

    else if(ccif.iREN[0]) //I-Fetch Operation
    begin
      ccif.ramREN = 1; //Assert RAM Read-Only Enable
      ccif.ramaddr = ccif.iaddr[0];  //Fetch the instruction from the address

      if(ccif.ramstate == ACCESS) begin
        //Data Line
        ccif.iload[0] = ccif.ramload;
        ccif.iwait[0] = 0; //iwait = 1 means "I-ready"
      end
    end

  end
  


endmodule
