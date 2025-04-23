`timescale 1ns / 1ps

module spi_master_tb_16bit;

  // Сигналы
  reg clk;
  reg rst_n;
  reg start;
  wire sclk;
  wire cs_n;
  wire mosi;
  reg miso;
  wire [15:0] adc_data;

  reg [15:0] input_data;
  integer i;

  // Подключение модуля
  spi_master_16bit uut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .miso(miso),
    .adc_data(adc_data)
  );

  // Генерация тактового сигнала
  always #10 clk = ~clk;

  // Инициализация
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, spi_master_tb_16bit);
  end

  initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    miso = 0;
    input_data = 16'b1010101010101010;

    // Сброс
    #50;
    rst_n = 1;
    #20;

    // Запуск SPI-передачи
    start = 1;
    #20;
    start = 0;

    // Подача данных на MISO синхронно со SPI тактами
    for (i = 15; i >= 0; i = i - 1) begin
      @(negedge sclk);
      miso = input_data[i];
    end

    // Ожидание завершения
    #200;
    $display("ADC Data = %b", adc_data);
    $finish;
  end

endmodule
