module top_axi_slave_wrapper (
    input  logic clk,
    input  logic rst,

    input  logic [31:0] axi_wdata,
    input  logic [31:0] axi_addr,
    input  logic        axi_write,
    input  logic        axi_read,
    output logic [31:0] axi_rdata,

    input  logic [5:0]  injected_bit1,
    input  logic [5:0]  injected_bit2,

    output logic single_error,
    output logic double_error,
    output logic [31:0] corrupted_data
);

logic [38:0] encoded_data;
logic [38:0] mem_data_out;
logic [31:0] decoded_data;

secded_encoder_32 enc (
    .data_in  (axi_wdata),
    .code_out (encoded_data)
);

memory_controller mem (
    .clk      (clk),
    .addr     (axi_addr),
    .write_en (axi_write),
    .read_en  (axi_read),
    .data_in  (encoded_data),
    .data_out (mem_data_out)
);

secded_decoder_32 dec (
    .data_in        (mem_data_out),
    .bit_flip1      (injected_bit1),
    .bit_flip2      (injected_bit2),
    .data_out       (decoded_data),
    .corrupted_out  (corrupted_data),
    .single_error   (single_error),
    .double_error   (double_error)
);

assign axi_rdata = decoded_data;

endmodule
