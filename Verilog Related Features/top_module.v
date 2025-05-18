module top_module (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire [15:0] adc_data,
    output wire [15:0] fifo_output,
    output wire fifo_out_valid
);

  // --- Внутренние соединения ---
  wire [15:0] result_data;
  wire        wr_en;
  wire        fifo_empty;
  wire        rd_en;

  // FIFO output
  wire [15:0] data_out;

  // --- Модуль обработки данных ---
  data_processing dp_inst (
    .clk(clk),
    .rst(rst),
    .adc_data(adc_data),
    .valid_in(valid_in),
    .wr_en(wr_en),
    .result_data(result_data)
  );

  // --- FIFO ---
  fifo_16bit fifo_inst (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(result_data),
    .data_out(data_out),
    .full(),       // не используется
  );

  // --- Автоматическое считывание из FIFO ---
  // Считываем данные, когда FIFO не пуст
  assign rd_en = ~fifo_empty;

  // Выходные сигналы
  assign fifo_output = data_out;
  assign fifo_out_valid = ~fifo_empty;

endmodule
