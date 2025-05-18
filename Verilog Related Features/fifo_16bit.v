module fifo_16bit(
    input         clk,       // системный тактовый сигнал
    input         rst,       // асинхронный сброс (active high)
    input         wr_en,     // сигнал разрешения записи
    input         rd_en,     // сигнал разрешения чтения
    input  [15:0] data_in,   // входные 16-битные данные
    output reg [15:0] data_out, // выходные 16-битные данные
    output        full,      // сигнал, что FIFO заполнен
    output        empty      // сигнал, что FIFO пуст
);

  // Параметры FIFO
  parameter DEPTH = 16;   // Глубина массива памяти FIFO
  parameter ADDR_WIDTH = 4; // поскольку 16 = 2^4

  // Определяем память FIFO (16 элементов по 12 бит)
  reg [15:0] mem [0:DEPTH-1];   // Массив для хранения 16 16-битных слов

  // Указатели для записи и чтения
  reg [ADDR_WIDTH-1:0] wr_ptr;    // Куда записывается слово
  reg [ADDR_WIDTH-1:0] rd_ptr;    // Откуда считывается

  // Счётчик количества элементов в FIFO
  reg [ADDR_WIDTH:0] count;

  // Генерация флагов full и empty на основе count
  assign full  = (count == DEPTH);
  assign empty = (count == 0);

  // Основной блок: управление записью и чтением из FIFO
  always @(posedge clk or posedge rst) begin
    if (rst) begin    // При активном сбросе все указатели и счётчик обнуляются
      wr_ptr   <= 0;
      rd_ptr   <= 0;
      count    <= 0;
      data_out <= 0;

    end else begin
      // Если одновременно включены и запись, и чтение,
      // то производится запись и чтение одновременно – счётчик остаётся неизменным.
      if (wr_en && !full && rd_en && !empty) begin
        mem[wr_ptr] <= data_in;
        data_out   <= mem[rd_ptr];
        wr_ptr     <= wr_ptr + 1;
        rd_ptr     <= rd_ptr + 1;
      end
      else if (wr_en && !full) begin    // Запись данных, если массив mem не полон, счётчик +
        mem[wr_ptr] <= data_in;
        wr_ptr     <= wr_ptr + 1;
        count      <= count + 1;
      end
      else if (rd_en && !empty) begin   // Считывание данных, если массив не пуст, счётчик -
        data_out   <= mem[rd_ptr];
        rd_ptr     <= rd_ptr + 1;
        count      <= count - 1;
      end
    end
  end

endmodule
