`timescale 1ns / 1ps

module data_processing_tb;

  reg clk;
  reg rst;
  reg [15:0] adc_data;
  reg valid_in;
  wire wr_en;
  wire [15:0] result_data;

  // Instantiate the data_processing module
  data_processing uut (
    .clk(clk),
    .rst(rst),
    .adc_data(adc_data),
    .valid_in(valid_in),
    .wr_en(wr_en),
    .result_data(result_data)
  );

  // Clock generation (50 MHz)
  always #10 clk = ~clk;

  // VCD file for GTKWave
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, data_processing_tb);
  end

  initial begin
    // Initial values
    clk = 0;
    rst = 1;
    valid_in = 0;
    adc_data = 0;

    #40;
    rst = 0;

    // Test 1: adc_data = 0x0000 (0 V)
    @(posedge clk);
    adc_data = 16'h0000;
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;

    // Test 2: adc_data = 0x4000 (≈ 0.4 V)
    repeat (2) @(posedge clk);
    adc_data = 16'h4000;
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;

    // Test 3: adc_data = 0x8000 (≈ 0.8 V)
    repeat (2) @(posedge clk);
    adc_data = 16'h8000;
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;

    // Test 4: adc_data = 0xC000 (≈ 1.2 V)
    repeat (2) @(posedge clk);
    adc_data = 16'hC000;
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;

    // Test 5: adc_data = 0xFFFF (≈ 1.6 V)
    repeat (2) @(posedge clk);
    adc_data = 16'hFFFF;
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;

    // End simulation
    #100;
    $finish;
  end

endmodule
