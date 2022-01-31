/*
  Fahad Tajiki
  ftajiki@gmail.com

  all types used to make life easier.

  Shubham Rastogi
  shubhamrastogi3111995@gmail.com

  cuif structs added
  
*/
`ifndef CUIF_TYPES_PKG_VH
`define CUIF_TYPES_PKG_VH
package cuif_types_pkg;

 typedef enum logic [1:0] {
    ctrlJR = 2'b10,
    ctrlJ = 2'b01,
    ctrlDefault = 2'b00
  } jctrl;

  typedef enum logic [1:0] {
    ctrlIMM = 2'b11,
    ctrlNPC = 2'b10,
    ctrlMEMDATA = 2'b01,
    ctrlALURESULT = 2'b00
  } wctrl;

   typedef enum logic [1:0] {
    ctrlSIGN = 2'b10,
    ctrlMSB = 2'b01,
    ctrlLSB = 2'b00
   } ectrl;


endpackage
`endif //CUIF_TYPES_PKG_VH
