`timescale 1ns / 1ps

module spi_master_tb;

  // Локальные сигналы
  reg clk;
  reg rst_n;
  wire sclk;
  wire cs_n;
  wire mosi;
  reg miso;
  wire [11:0] adc_data;

  // Экземпляр (Unit Under Test) модуля spi_master
  spi_master uut (
    .clk(clk),
    .rst_n(rst_n),
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .miso(miso),
    .adc_data(adc_data)
  );

  // Генерация тактового сигнала: 50 МГц => период 20 нс
  always #10 clk = ~clk;

  // Для записи в VCD-файл (просмотр в GTKWave)
  initial begin
    $dumpfile("dump.vcd");   // Имя файла с "волнами"
    $dumpvars(0, spi_master_tb); // Записываем все сигналы уровня 0 (весь тестбенч)
  end

  initial begin
    // Инициализация
    clk = 0;
    rst_n = 0;
    miso = 0;

    // Держим сброс немного
    #50;
    rst_n = 1;
    #20;

    // Запускаем SPI
    uut.start_spi();

    // Эмулируем приход 12 бит на MISO
    // Для теста передаем 12'b101010101010

    repeat (12) begin
      miso = 1;  // здесь можно чередовать 0/1
      #20;
      miso = 0;
      #20;
    end

    // Немного ждём и завершаем
    #200;
    $display("ADC Data = %b", adc_data);
    $finish;
  end

endmodule
