module memory_controller (
    input  logic        clk,
    input  logic [31:0] addr,
    input  logic        write_en,
    input  logic        read_en,
    input  logic [38:0] data_in,
    output logic [38:0] data_out
);

    logic [38:0] mem [0:255];

    always_ff @(posedge clk) begin
        if (write_en)
            mem[addr] <= data_in;
    end

    assign data_out = (read_en) ? mem[addr] : '0;

endmodule
