module spi_master (
    input wire clk,
    input wire rst_n,
    output reg sclk,
    output reg cs_n,
    output reg mosi,
    input wire miso,
    output reg [11:0] adc_data
);

reg [3:0] bit_cnt;
reg [11:0] data_buf;
reg spi_active;

// Основной always-блок
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cs_n <= 1;
        sclk <= 0;
        bit_cnt <= 0;
        spi_active <= 0;
    end else begin
        if (spi_active) begin
            sclk <= ~sclk; // Генерируем SPI SCLK
            if (sclk) begin
                if (bit_cnt < 12) begin
                    data_buf <= {data_buf[10:0], miso};
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

// Задача запуска SPI
task start_spi;
    begin
        cs_n <= 0;
        bit_cnt <= 0;
        spi_active <= 1;
    end
endtask

endmodule
