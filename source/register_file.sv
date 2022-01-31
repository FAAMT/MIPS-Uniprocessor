`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

module register_file
(
    input logic CLK, nRST,
    register_file_if.rf rfif
);


logic [31:0][31:0] register; //Each location is 32 bits wide.

always_ff @(posedge CLK or negedge nRST) begin
    if (!nRST) begin
        register <= '{default: '0}; //An active low asynchronous reset will reset all modifiable locations to a value of 0x00000000.
    end
    else begin
        if (rfif.WEN) begin
            register[rfif.wsel] <= rfif.wdat;
        end

        register[0] <= 32'd0;
    end
end

assign rfif.rdat1 = register[rfif.rsel1];
assign rfif.rdat2 = register[rfif.rsel2];

endmodule