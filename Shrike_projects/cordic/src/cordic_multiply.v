// cordic_multiply.v
// Author: Yash Sharda
// Shift-and-add integer multiplier using 3 iterations.
// Computes in1 * in2 and returns the result in out.

module cordic_multiply (
    input  wire              clk,
    input  wire              rst_n,
    input  wire              start,
    input  wire signed [7:0] in1,  // multiplicand
    input  wire signed [7:0] in2,  // multiplier
    output reg  signed [7:0] out,  // product
    output reg               done
);

    reg signed [7:0] x;
    reg signed [7:0] y;
    reg signed [7:0] z;
    reg [2:0]        i;
    reg [1:0]        state;

    localparam IDLE  = 2'd0;
    localparam APPROX = 2'd1;
    localparam DONE  = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            out   <= 8'sd0;
            done  <= 1'b0;
            i     <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        x     <= in1;
                        y     <= 8'sd0;
                        z     <= in2;
                        i     <= 3'd0;
                        state <= APPROX;
                    end
                end

                APPROX: begin
                    // Accumulate shifted x into y for each set bit in z
                    if (z[0] == 1'b1) begin
                        y <= y + (x << i);
                    end
                    z <= z >>> 1;
                    if (i == 3'd2) begin
                        state <= DONE;
                    end else begin
                        i <= i + 3'd1;
                    end
                end

                DONE: begin
                    done  <= 1'b1;
                    out   <= y;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
