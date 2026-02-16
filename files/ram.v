`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2026 22:24:54
// Design Name: 
// Module Name: ram
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



module ram #(
    parameter DATA_WIDTH = 24, // 3 columns * 8 bits = 24 bits wide
    parameter ADDR_WIDTH = 4,  // Enough for 16 lines of data
    parameter MEM_FILE = ""    // Filename to load
)(
    input clk,
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] data_out
);

    // 1. Define the Memory Array
    reg [DATA_WIDTH-1:0] memory [0:(2**ADDR_WIDTH)-1];

    // 2. Initialize Memory from File
    integer i;
    initial begin

    for (i=0; i<16; i=i+1) memory[i] = 0;
            if (MEM_FILE != "") 
            $readmemh(MEM_FILE, memory);
             $display("RAM loaded from %s, addr[0]=%h", MEM_FILE, memory[0]);
        
    end

    // 3. Synchronous Read
    always @(posedge clk) begin
        data_out <= memory[addr];
    end

    
endmodule
