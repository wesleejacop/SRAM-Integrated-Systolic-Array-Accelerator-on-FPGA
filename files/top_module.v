`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



// --- 1. MODULE START ---
module top_module #(
    parameter N = 3,
    parameter D_W = 8,
    parameter A_W = 24
)(
    input clk,
    input rst,
    input start,               // The "Go" button
    output [N*A_W-1:0] results // The final output bus
);

    // --- INTERNAL WIRES ---
    wire [N*D_W-1:0] w_data_from_ram;
    wire [N*D_W-1:0] b_data_from_ram;
    
    // Registers to control the RAMs
    reg [3:0] w_addr;
    reg [3:0] b_addr;
    
    // Registers to control the Array
    reg load_weight_enable;
    reg [1:0] load_row_idx;
    
    // FSM State Definitions
    localparam IDLE = 0, LOAD_W = 1, STREAM = 2, DONE = 3;
    reg [1:0] state;

    
    
    // Weight RAM Instance
    ram #(.MEM_FILE("C:/Users/WESLEE/systolic_array/weights.mem")) weight_ram (
        .clk(clk),
        .addr(w_addr),
        .data_out(w_data_from_ram)
    );

    // Input RAM Instance
    ram #(.MEM_FILE("C:/Users/WESLEE/systolic_array/inputs.mem")) input_ram (
        .clk(clk),
        .addr(b_addr),
        .data_out(b_data_from_ram)
    );

    // Systolic Array Instance
    systolic_array #(.N(N), .D_W(D_W), .A_W(A_W)) array_core (
        .clk(clk),
        .rst(rst),
        .load_w(load_weight_enable),
        .load_idx(load_row_idx),
        .w_in_bus(w_data_from_ram),
        .b_in_bus(b_data_from_ram),
        .c_out_bus(results)
    );

    // --- 3. CONTROL LOGIC (The Brain) ---
    
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            w_addr <= 0;
            b_addr <= 0;
            load_weight_enable <= 0;
            load_row_idx <= 0;
        end 
        else begin
            case (state)
                IDLE: begin
                    if (start) state <= LOAD_W;
                end

                LOAD_W: begin
                    load_weight_enable <= 1;
                    load_row_idx <= w_addr[1:0];
                    
                    if (w_addr == N-1) begin
                        state <= STREAM;
                        w_addr <= 0; 
                    end else begin
                        w_addr <= w_addr + 1;
                    end
                end

                STREAM: begin
                    load_weight_enable <= 0;
                    
                    // We read enough lines to cover our skewed input
                    if (b_addr == 6) begin
                        state <= DONE;
                    end else begin
                        b_addr <= b_addr + 1;
                    end
                end

                DONE: begin
                    state <= DONE;
                end
            endcase
        end
    end

endmodule 
