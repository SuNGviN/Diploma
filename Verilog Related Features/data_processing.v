module data_processing (
    input wire clk,
    input wire rst,
    input wire [15:0] adc_data,     // Входной код с АЦП
    input wire valid_in,            // Флаг: данные готовы
    output reg wr_en,               // Запись в FIFO разрешена
    output reg [15:0] result_data   // Результат обработки
);

  // Параметры масштабирования
  parameter SCALE = 1000;  // Масштаб в милливольтах
  parameter SHIFT = 16;    // Сдвиг вправо, аналог деления

  reg [31:0] scaled_temp;  // Временная переменная для расчёта

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      result_data <= 0;
      wr_en <= 0;
      scaled_temp <= 0;
    end else begin
      if (valid_in) begin
        scaled_temp <= adc_data * SCALE;              // Умножаем
        result_data <= scaled_temp >> SHIFT;          // Сдвигаем
        wr_en <= 1;
      end else begin
        wr_en <= 0;
      end
    end
  end

endmodule
