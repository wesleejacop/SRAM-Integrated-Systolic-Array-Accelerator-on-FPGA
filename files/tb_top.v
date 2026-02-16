`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 16:34:30
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module tb_top;

    reg clk, rst, start;
    wire [71:0] final_results;

    // Instantiate the Full System (RAM + Array)
    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .results(final_results)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; start = 0;
        #20 rst = 0;

        // Press Start Button
        #10 start = 1;
        #10 start = 0;

        // Wait for the machine to do everything automatically
        #200;
        
        $stop;
    end

endmodule
