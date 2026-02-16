
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2025 18:04:54
// Design Name: 
// Module Name: systolic_array
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
module systolic_array #(
parameter D_W=8,
parameter A_W=24,
parameter N=3
 )
 (
input clk,rst,
input load_w,
input [1:0]load_idx,

input [N*D_W-1:0]w_in_bus,
input [N*D_W-1:0]b_in_bus,
output [N*A_W-1:0]c_out_bus
);

// horizontal and vertical wires for connection bw PEs
wire [D_W-1:0]h_wire[0:N-1][0:N];
wire [A_W-1:0]v_wire[0:N][0:N-1];

genvar r,c;
generate 
for(r=0;r<N;r=r+1) begin : ROWS
   for(c=0;c<N;c=c+1) begin : COL
   

 wire [D_W-1:0] my_left_in  = (c == 0) ? b_in_bus[r*D_W +: D_W]
                                            : h_wire[r][c];

      // Psum input: 0 for first row, else from top neighbor
      wire [A_W-1:0] my_psum_in  = (r == 0) ? {A_W{1'b0}}
                                            : v_wire[r][c];
//weight loading

wire my_load_en = load_w && (load_idx==r);
wire [D_W-1:0]my_weight = w_in_bus[c*D_W +: D_W];

pe #(.D_W(D_W), .A_W(A_W)) pe_inst (
      .clk(clk),
      .rst(rst),
                    
      .load_weight(my_load_en),
      .weight_in(my_weight),
                    
       .left_in(my_left_in),
        .right_out(h_wire[r][c+1]), // Drive wire to Right
                    
        .psum_in(my_psum_in),
        .psum_out(v_wire[r+1][c])      // Drive wire to South
    );

end
end 
endgenerate
 //output
 genvar k;
 generate 
 for(k=0;k<N;k=k+1) begin : OUT
    assign  c_out_bus[k*A_W +: A_W] = v_wire[N][k];
   end
   endgenerate
endmodule   
   
 


    

