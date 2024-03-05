module testbench();

reg clk;
reg rst;
reg mosi;
wire miso;
wire ss0;
wire ss1;
wire sclk;
reg [7:0] master_data_in;
wire slave_miso;

spi_master master (
    .clk(clk),
    .rst(rst),
    .mosi(mosi),
    .miso(miso),
    .ss0(ss0),
    .ss1(ss1),
    .sclk(sclk)
);

spi_slave slave0 (
    .clk(clk),
    .rst(rst),
    .sclk(sclk),
    .mosi(mosi),
    .miso(slave_miso),
    .ss(ss0)
);

spi_slave slave1 (
    .clk(clk),
    .rst(rst),
    .sclk(sclk),
    .mosi(mosi),
    .miso(slave_miso),
    .ss(ss1)
);

initial begin
    clk = 0;
    rst = 1;
    mosi = 1;
    master_data_in = 8'b0;
    #10 rst = 0;
    #100;
    // Test with ss0 active
    master_data_in = 8'b10101010;
    ss0 = 0;
    #100;
    ss0 = 1;
    // Test with ss1 active
    master_data_in = 8'b01010101;
    ss1 = 0;
    #100;
    ss1 = 1;
    // Add more test scenarios as needed
    $stop;
end

always #5 clk = ~clk;

endmodule
