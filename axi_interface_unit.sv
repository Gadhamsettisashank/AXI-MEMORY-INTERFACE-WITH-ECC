module axi_interface_unit (
    axi_if axi,
    input  logic ACLK,
    output logic [31:0] wdata_out,
    output logic [7:0]  addr_out,
    input  logic [31:0] rdata_in
);
    assign axi.AWREADY = 1;
    assign axi.WREADY  = 1;
    assign axi.ARREADY = 1;

    assign wdata_out = axi.WDATA;
    assign addr_out  = axi.AWADDR[7:0];
    assign axi.RDATA = rdata_in;

    assign axi.BVALID = axi.AWVALID & axi.WVALID;
    assign axi.RVALID = axi.ARVALID;
endmodule

