module spi_master_16bit (
    input wire clk,             // Системная тактовая частота (50 МГц)
    input wire rst_n,           // Сброс (активный низкий)
    input wire start,           // Новый управляющий сигнал: запуск передачи
    output reg sclk,            // Тактовый сигнал SPI
    output reg cs_n,            // Chip Select (активный низкий)
    output reg mosi,            
    input wire miso,            // Данные от АЦП
    output reg [15:0] adc_data  // 16 бит данных
);

reg [3:0] bit_cnt;              // Счётчик принятых бит
reg [15:0] data_buf;           // Буфер приёма
reg spi_active;                // Флаг активности SPI

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cs_n <= 1;
        sclk <= 0;
        bit_cnt <= 0;
        spi_active <= 0;
        adc_data <= 0;
    end else begin
        if (start && !spi_active) begin
            cs_n <= 0;
            bit_cnt <= 0;
            spi_active <= 1;
            sclk <= 0;
        end else if (spi_active) begin
            sclk <= ~sclk;

            if (sclk) begin
                if (bit_cnt < 16) begin
                    data_buf <= {data_buf[14:0], miso};
                    bit_cnt <= bit_cnt + 1;
                end else begin
                    adc_data <= data_buf;
                    cs_n <= 1;
                    spi_active <= 0;
                end
            end
        end
    end
end

endmodule
