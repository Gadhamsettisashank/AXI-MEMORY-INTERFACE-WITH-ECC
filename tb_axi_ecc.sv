`timescale 1ns/1ps

module tb_axi_ecc;

logic ACLK, ARESETN;
logic write_en, read_en;
logic [31:0] addr, data, rdata;
logic [5:0] b1, b2;
logic [38:0] raw_mem_data;

int tc;
string err_string;


// CLOCK
initial ACLK = 0;
always #5 ACLK = ~ACLK;


// DUT instantiation 
top_axi_slave_wrapper dut (
    .clk(ACLK),
    .rst(~ARESETN),
    .axi_wdata(data),
    .axi_addr(addr),
    .axi_write(write_en),
    .axi_read(read_en),
    .axi_rdata(rdata),
    .injected_bit1(b1),
    .injected_bit2(b2),
    .single_error(),
    .double_error()
);


// WRITE TASK
task axi_write(input [31:0] a, input [31:0] d);
begin
    @(posedge ACLK);
    addr = a; 
    data = d;
    write_en = 1; 
    read_en = 0;
    @(posedge ACLK);
    write_en = 0;
end
endtask


// READ TASK
task axi_read(input [31:0] a);
begin
    @(posedge ACLK);
    addr = a;
    read_en = 1; 
    write_en = 0;
    @(posedge ACLK);
    read_en = 0;
end
endtask


// PRINT REPORT TASK (UPDATED WITH ADDRESS)
task print_report(
    input int tcase,
    input [31:0] address,
    input [31:0] orig,
    input [31:0] corrupt,
    input [31:0] corrected,
    input [5:0] bit1,
    input [5:0] bit2,
    input string errtype
);
begin
    $display("----------------------------------------------------");
    $display("TEST CASE        : %0d", tcase);
    $display(" writing data into SRAM ");
    $display("Address          : 0x%08h", address);
    $display("Original Data    : 0x%08h", orig);

    if (bit1 == 6'd63 && bit2 == 6'd63)
        $display("Injected Error Bit(s): NONE");
    else if (bit2 == 6'd63)
        $display("Injected Error Bit : %0d", bit1);
    else
        $display("Injected Error Bits: %0d , %0d", bit1, bit2);

    $display("Corrupted Data   : 0x%08h", corrupt);
    $display(" Reading data from SRAM ");
    $display("Corrected Data   : 0x%08h", corrected);
    $display("ERROR TYPE       : %s", errtype);
    $display("----------------------------------------------------\n");
end
endtask


// TEST SEQUENCE
initial begin
    tc = 1;
    ARESETN = 0;
    write_en = 0; 
    read_en = 0;
    #20 ARESETN = 1;


    // TEST CASES 1–4 : NO ERROR
    repeat (4) begin
        addr = $urandom_range(0,100);
        data = $random;
        b1 = 6'd63; 
        b2 = 6'd63;

        axi_write(addr, data);
        axi_read(addr);
        raw_mem_data = dut.mem_data_out;

        err_string = "NO ERROR";
        print_report(tc++, addr, data, raw_mem_data[31:0], rdata, b1, b2, err_string);
    end


    // TEST CASES 5–8 : SINGLE BIT ERROR
    repeat (4) begin
        addr = $urandom_range(0,100);
        data = $random;

        b1 = $urandom_range(0,31);  
        b2 = 6'd63;

        axi_write(addr, data);
        axi_read(addr);
        raw_mem_data = dut.corrupted_data;

        err_string = "SINGLE BIT ERROR (CORRECTED)";
        print_report(tc++, addr, data, raw_mem_data[31:0], rdata, b1, b2, err_string);
    end


    // TEST CASES 9–12 : DOUBLE BIT ERROR
    repeat (4) begin
        addr = $urandom_range(0,100);
        data = $random;

        b1 = $urandom_range(0,38);
        b2 = (b1 + 5) % 39;

        axi_write(addr, data);
        axi_read(addr);
        raw_mem_data = dut.corrupted_data;

        err_string = "DOUBLE BIT ERROR (DETECTED)";
        print_report(tc++, addr, data, raw_mem_data[31:0], rdata, b1, b2, err_string);
    end

    $display("ALL 15 TEST CASES COMPLETED =========");
    #20 $finish;
end

endmodule