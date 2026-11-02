interface axi_if;
    logic ARESETn;

    logic [31:0] AWADDR, WDATA, ARADDR, RDATA;
    logic AWVALID, WVALID, ARVALID;
    logic AWREADY, WREADY, ARREADY;

    logic [1:0] BRESP, RRESP;
    logic BVALID, BREADY, RVALID, RREADY;
endinterface

