module rtl_wrapper;

logic clk;
logic rst;

logic [31:0] axi_wdata;
logic [31:0] axi_addr;
logic axi_write;
logic axi_read;
logic [31:0] axi_rdata;

logic [5:0] injected_bit1;
logic [5:0] injected_bit2;

logic single_error;
logic double_error;
logic [31:0] corrupted_data;


// Clock

initial clk = 0;
always #5 clk = ~clk;


// Reset

initial begin
    rst = 1;
    #20 rst = 0;
end


// DUT instantiation 

top_axi_slave_wrapper dut (
    .clk(clk),
    .rst(rst),

    .axi_wdata(axi_wdata),
    .axi_addr(axi_addr),
    .axi_write(axi_write),
    .axi_read(axi_read),
    .axi_rdata(axi_rdata),

    .injected_bit1(injected_bit1),
    .injected_bit2(injected_bit2),

    .single_error(single_error),
    .double_error(double_error),
    .corrupted_data(corrupted_data)
);

endmodule
