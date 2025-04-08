module spi_master (
    input wire clk,     // Системная тактовая частота (50 МГц)
    input wire rst_n,   // Сброс (активный, когда 0/"активный низкий")
    output reg sclk,    // Тактовый сигнал SPI
    output reg cs_n,    // Chip Select, выбор АЦП (активный 0)
    output reg mosi,    // Данные от мастера
    input wire miso,    // Данные от АЦП
    output reg [11:0] adc_data  // Принятые 12 бит данных
);

reg [3:0] bit_cnt;  // Счётчик, сколько битов данных было передано/принято
reg [11:0] data_buf;    // Буфер, для приёма данных
reg spi_active;     // Активна ли передача данных по SPI?

// Основной always-блок
// Выполняется при: по переднему фронту тактового сигнала / по спаду сигнала сброса
always @(posedge clk or negedge rst_n) begin

    // Условие сброса
    if (!rst_n) begin   // Сигнал сброса активен rst_n = 0
        cs_n <= 1;      // Сброс сигнала Chip Select.
        sclk <= 0;      // Сюрос тактового сигнала
        bit_cnt <= 0;   // Обнуляем счетчик переданных битов
        spi_active <= 0;    // Остановка передачи данных

    end else begin      // Сигнал сброса неактивен rst_n = 1

        if (spi_active) begin   // Активна ли передача данных?
            sclk <= ~sclk; // Генерируем SPI SCLK

            // Чтение данных по MISO.
            if (sclk) begin     // Выполнение на положительном/отрицательном фронте SCLK
                if (bit_cnt < 12) begin
                    data_buf <= {data_buf[10:0], miso};     // data_buf[10:0] - сдвиг данных влево на 1 бит, miso - принимаем следующий бит
                    bit_cnt <= bit_cnt + 1;

                end else begin      // 12 битов уже принято
                    adc_data <= data_buf;       // Запись результата из буфера
                    cs_n <= 1;                  // Отключение АЦП (Chip Select)
                    spi_active <= 0;            // Завершение передачи
                end
            end
        end
    end
end

// Задача запуска SPI
task start_spi;     // Процедура для вызова запуска SPI
    begin
        cs_n <= 0;
        bit_cnt <= 0;
        spi_active <= 1;
    end
endtask

endmodule
