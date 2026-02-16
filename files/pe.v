`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2025 18:32:34
// Design Name: 
// Module Name: pe
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
module pe#(
parameter D_W=8,
parameter A_W=24
)(
input clk,rst,
input load_weight,
input [D_W-1:0]left_in,
input [D_W-1:0]weight_in,
input [A_W-1:0]psum_in,
output reg  [D_W-1:0]right_out,
output [A_W-1:0]psum_out
);
reg [D_W-1:0]stored_weight;
mac_unit# (.D_W(D_W), .A_W(A_W)) core(
.clk(clk),
.rst(rst),
.a_in(left_in),
.w_in(stored_weight),
.p_in(psum_in),
.p_out(psum_out)
);
// load weight

always@(posedge clk)
begin
if(rst) begin
stored_weight<=0;
right_out<=0;
end
else begin
right_out<=left_in;
if (load_weight) begin
stored_weight<=weight_in;
end
end
end
endmodule




