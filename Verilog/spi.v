module spi_master (
    input wire clk,
    input wire rst,
    input wire miso,
    output reg mosi,
    output reg ss0,
    output reg ss1,
    output reg sclk
);

reg [7:0] tx_data;
reg [2:0] bit_counter;
reg ss_active;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx_data <= 8'b0;
        bit_counter <= 3'b0;
        mosi <= 1'b0;
        ss0 <= 1'b1;
        ss1 <= 1'b1;
        sclk <= 1'b0;
        ss_active <= 1'b0;
    end else begin
        if (ss0 || ss1) begin
            ss_active <= 1'b1;
            if (bit_counter < 3) begin
                sclk <= ~sclk;
                if (sclk) begin
                    mosi <= tx_data[7];
                    tx_data <= {tx_data[6:0], miso};
                    bit_counter <= bit_counter + 1;
                end
            end else begin
                sclk <= 1'b0;
                mosi <= 1'b0;
                bit_counter <= 3'b0;
            end
        end else begin
            ss_active <= 1'b0;
            mosi <= 1'b0;
            sclk <= 1'b0;
            bit_counter <= 3'b0;
        end
    end
end

endmodule

module spi_slave (
    input wire clk,
    input wire rst,
    input wire sclk,
    input wire mosi,
    output reg miso,
    input wire ss
);

reg [7:0] rx_data;
reg [2:0] bit_counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_data <= 8'b0;
        miso <= 1'b0;
        bit_counter <= 3'b0;
    end else begin
        if (~ss) begin
            if (sclk) begin
                rx_data <= {rx_data[6:0], mosi};
                if (bit_counter < 3) begin
                    miso <= rx_data[7];
                    bit_counter <= bit_counter + 1;
                end else begin
                    miso <= 1'b0;
                    bit_counter <= 3'b0;
                end
            end
        end
    end
end

endmodule
