module secded_encoder_32 (
    input  logic [31:0] data_in,
    output logic [38:0] code_out
);
    logic [6:0] parity;

    always_comb begin
        parity[0] = ^data_in[7:0];
        parity[1] = ^data_in[15:8];
        parity[2] = ^data_in[23:16];
        parity[3] = ^data_in[31:24];
        parity[4] = ^data_in[15:0];
        parity[5] = ^data_in[31:16];
        parity[6] = ^data_in;

        code_out = {parity, data_in};
    end
endmodule
