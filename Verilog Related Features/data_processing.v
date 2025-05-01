module data_processing (
    input wire clk,
    input wire rst,
    input wire [15:0] adc_data,     // Код от АЦП
    input wire valid_in,            // Сигнал готовности
    output reg wr_en,               // Включение FIFO
    output reg [15:0] result_data   // ln(V) в формате 8.8
);

  parameter SCALE = 1000;
  parameter SHIFT = 16;

  reg [15:0] millivolts;
  reg [15:0] x_ln;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_en <= 0;
      millivolts <= 0;
      x_ln <= 0;
      result_data <= 0;
    end else begin
      if (valid_in) begin
        // Этап 1: Перевод в мВ (adc_data * SCALE >> SHIFT)
        millivolts <= (adc_data * SCALE) >> SHIFT;

    // Этап 2: Аппроксимация ln(mV)
    if (millivolts >= 1 && millivolts <= 100)
        x_ln <= (12 * millivolts + (-12));
    else if (millivolts >= 101 && millivolts <= 200)
        x_ln <= (2 * millivolts + 1004);
    else if (millivolts >= 201 && millivolts <= 300)
        x_ln <= (1 * millivolts + 1150);
    else if (millivolts >= 301 && millivolts <= 400)
        x_ln <= (1 * millivolts + 1240);
    else if (millivolts >= 401 && millivolts <= 500)
        x_ln <= (1 * millivolts + 1306);
    else if (millivolts >= 501 && millivolts <= 600)
        x_ln <= (0 * millivolts + 1358);
    else if (millivolts >= 601 && millivolts <= 700)
        x_ln <= (0 * millivolts + 1401);
    else if (millivolts >= 701 && millivolts <= 800)
        x_ln <= (0 * millivolts + 1438);
    else if (millivolts >= 801 && millivolts <= 900)
        x_ln <= (0 * millivolts + 1470);
    else if (millivolts >= 901 && millivolts <= 1000)
        x_ln <= (0 * millivolts + 1499);
    else
        x_ln <= 0;


        // Этап 3: Запись результата
        result_data <= x_ln;
        wr_en <= 1;
      end else begin
        wr_en <= 0;
      end
    end
  end

endmodule
