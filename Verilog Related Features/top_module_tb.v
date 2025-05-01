`timescale 1ns / 1ps

module top_module_tb;

  reg clk;
  reg rst;
  reg valid_in;
  reg [15:0] adc_data;

  wire [15:0] fifo_output;
  wire fifo_out_valid;

  // Instantiate top-level module
  top_module uut (
    .clk(clk),
    .rst(rst),
    .valid_in(valid_in),
    .adc_data(adc_data),
    .fifo_output(fifo_output),
    .fifo_out_valid(fifo_out_valid)
  );

  // --- UART симуляция: запись результата в файл ---
  integer fout;
  initial fout = $fopen("uart_output.txt", "w");

  always @(posedge clk) begin
    if (fifo_out_valid) begin
      $fdisplay(fout, "%d", fifo_output);
    end
  end

  // --- Clock generation (50 МГц) ---
  always #10 clk = ~clk;

  // --- Dump for GTKWave ---
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top_module_tb);
  end

  // --- Основная логика подачи данных ---
  reg [15:0] test_values [0:19];
  integer i;

  initial begin
    // Инициализация
    clk = 0;
    rst = 1;
    valid_in = 0;
    adc_data = 0;

    // Заполнение массива значениями ADC
    test_values[0]  = 16'h1000;
    test_values[1]  = 16'h1200;
    test_values[2]  = 16'h1400;
    test_values[3]  = 16'h1600;
    test_values[4]  = 16'h1800;
    test_values[5]  = 16'h2000;
    test_values[6]  = 16'h3000;
    test_values[7]  = 16'h4000;
    test_values[8]  = 16'h5000;
    test_values[9]  = 16'h6000;
    test_values[10] = 16'h7000;
    test_values[11] = 16'h8000;
    test_values[12] = 16'h9000;
    test_values[13] = 16'hA000;
    test_values[14] = 16'hB000;
    test_values[15] = 16'hB000;
    test_values[16] = 16'hA000;
    test_values[17] = 16'h8000;
    test_values[18] = 16'h4000;
    test_values[19] = 16'h1000;

    // Сброс
    #50;
    rst = 0;
    #20;

    // Подача значений
    for (i = 0; i < 20; i = i + 1) begin
      test_input(test_values[i]);
    end

    #500;
    $finish;
  end

  // --- Task подачи одного значения ---
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
