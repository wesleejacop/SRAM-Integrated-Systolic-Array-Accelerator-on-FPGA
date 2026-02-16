`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2025 18:32:34
// Design Name: 
// Module Name: mac_unit
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

module mac_unit #(
    parameter D_W = 8,   // Data Width (8-bit)
    parameter A_W = 24   // Accumulator Width (24-bit)
)(
    input clk, 
    input rst,
    input [D_W-1:0] a_in,      // Activation Input (from West)
    input [D_W-1:0] w_in,      // Weight Input (Stationary)
    input [A_W-1:0] p_in,      // Partial Sum Input (from North)
    output reg [A_W-1:0] p_out // Partial Sum Output (to South)
);

    always @(posedge clk) begin
        if (rst) begin
            p_out <= 0;
        end else begin
            // The MAC operation: Output = Top + (Left * Weight)
            p_out <= p_in + (a_in * w_in);
        end
    end

endmodule

