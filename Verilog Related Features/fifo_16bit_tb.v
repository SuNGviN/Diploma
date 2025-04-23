`timescale 1ns / 1ps

module fifo_16bit_tb;
  reg         clk;
  reg         rst;
  reg         wr_en;
  reg         rd_en;
  reg  [15:0] data_in;
  wire [15:0] data_out;
  wire        full;
  wire        empty;

  // Экземпляр FIFO
  fifo_16bit uut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Генерация тактового сигнала: период 20 ns (50 MHz)
  always #10 clk = ~clk;

  // Запись изменений сигналов в VCD-файл для просмотра в GTKWave
  initial begin
    $dumpfile("fifo_dump.vcd");
    $dumpvars(0, fifo_16bit_tb);
  end

  // Основной тестовый сценарий
  initial begin
    // Инициализация сигналов
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 16'd0;
    
    #25;  // Небольшая задержка для сброса
    rst = 0;

    // Запись 4 значений в FIFO
    wr_en = 1;
    data_in = 16'd100;  // Первое значение
    #20;
    data_in = 16'd200;  // Второе значение
    #20;
    data_in = 16'd300;  // Третье значение
    #20;
    data_in = 16'd400;  // Четвертое значение
    #20;
    wr_en = 0;

    // Небольшая пауза перед чтением
    #40;

    // Чтение данных из FIFO
    rd_en = 1;
    #20;  // Считываем первое слово
    rd_en = 0;
    #20;
    rd_en = 1;
    #20;  // Считываем второе слово
    rd_en = 0;
    #20;
    rd_en = 1;
    #20;  // Считываем третье слово
    rd_en = 0;
    #20;
    rd_en = 1;
    #20;  // Считываем четвёртое слово
    rd_en = 0;

    // Завершение симуляции
    #50;
    $finish;
  end

  // Мониторинг сигналов для отладки
  initial begin
    $monitor("Time=%0t | rst=%b | wr_en=%b | rd_en=%b | data_in=%d | data_out=%d | full=%b | empty=%b",
              $time, rst, wr_en, rd_en, data_in, data_out, full, empty);
  end

endmodule
