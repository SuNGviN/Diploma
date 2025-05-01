`timescale 1ns / 1ps

module data_processing_tb;

  reg clk;
  reg rst;
  reg valid_in;
  reg [15:0] adc_data;
  wire wr_en;
  wire [15:0] result_data;

  // Instantiate your data_processing module
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

  // Generate VCD for GTKWave
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, data_processing_tb);
  end

  initial begin
    // Initial setup
    clk = 0;
    rst = 1;
    valid_in = 0;
    adc_data = 0;

    #50;
    rst = 0;
    #20;

    // Test sequence:
    // We'll input ADC values that correspond to known voltages.

    // 1. Very low value (almost 0V)
    test_input(16'h0001);   // Expect very small ln value

    // 2. 0.4V (around 250 mV)
    test_input(16'h4000);   // Should land around ln(250)

    // 3. 0.8V (around 500 mV)
    test_input(16'h8000);   // Should land around ln(500)

    // 4. 1.2V (around 750 mV)
    test_input(16'hC000);   // Should land around ln(750)

    // 5. 1.6V (around 1000 mV)
    test_input(16'hFFFF);   // Should land around ln(1000)

    // End simulation
    #200;
    $finish;
  end

  // Task to apply input values easily
  task test_input(input [15:0] val);
    begin
      @(posedge clk);
      adc_data = val;
      valid_in = 1;
      @(posedge clk);
      valid_in = 0;
    end
  endtask

endmodule
