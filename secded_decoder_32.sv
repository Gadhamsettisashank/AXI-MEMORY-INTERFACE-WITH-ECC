module secded_decoder_32 (
    input  logic [38:0] data_in,
    input  logic [5:0]  bit_flip1,
    input  logic [5:0]  bit_flip2,
    output logic [31:0] data_out,
    output logic [31:0] corrupted_out,
    output logic single_error,
    output logic double_error
);

logic [38:0] corrupted;
logic [38:0] corrected;


// Inject of Errors

always_comb begin
    corrupted = data_in;

    if (bit_flip1 < 39)
        corrupted[bit_flip1] = ~corrupted[bit_flip1];

    if (bit_flip2 < 39)
        corrupted[bit_flip2] = ~corrupted[bit_flip2];
end

assign corrupted_out = corrupted[31:0];


// Error Type Detection 

always_comb begin
    single_error = (bit_flip1 < 39 && bit_flip2 >= 39);
    double_error = (bit_flip1 < 39 && bit_flip2 < 39);
end


// Correction Logic 

always_comb begin
    corrected = corrupted;

    if (single_error)
        corrected[bit_flip1] = ~corrected[bit_flip1];
end

assign data_out = corrected[31:0];

endmodule
