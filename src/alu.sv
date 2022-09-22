`timescale 1ns/100ps

typedef enum bit [3:0] {ADD, SUB, MUL, DIV,
                        LSL, RSL, ROTL, ROTR,
                        AND, OR, XOR, NAND,
                        NOR, XNOR, GREATER, EQUAL} e_alu_mode;

module alu (
    input   logic       clk,
    input   logic       reset_n,
    input   logic [7:0] in_dataA,
    input   logic [7:0] in_dataB,
    input   logic [3:0] in_mode,
    output  logic [7:0] out_data,
    output  logic       out_cout
);

    logic [7:0] alu_result;
    logic [8:0] tmp;

    always @ (posedge clk) begin : alumodes
        if (reset_n) begin
            case(in_mode)
                e_alu_mode'(0)  : alu_result = in_dataA + in_dataB;                 // add
                e_alu_mode'(1)  : alu_result = in_dataA - in_dataB;                 // subtract
                e_alu_mode'(2)  : alu_result = in_dataA * in_dataB;                 // multiply
                e_alu_mode'(3)  : alu_result = in_dataA / in_dataB;                 // divide
                e_alu_mode'(4)  : alu_result = in_dataA << 1;                       // left shift logical
                e_alu_mode'(5)  : alu_result = in_dataA >> 1;                       // right shift logical
                e_alu_mode'(6)  : alu_result = {in_dataA[6:0], in_dataA[7]};        // rotate left
                e_alu_mode'(7)  : alu_result = {in_dataA[0], in_dataA[7:1]};        // rotate right
                e_alu_mode'(8)  : alu_result = in_dataA & in_dataB;                 // logical and
                e_alu_mode'(9)  : alu_result = in_dataA | in_dataB;                 // logical or
                e_alu_mode'(10) : alu_result = in_dataA ^ in_dataB;                 // logical xor
                e_alu_mode'(11) : alu_result = ~(in_dataA & in_dataB);              // logical nand
                e_alu_mode'(12) : alu_result = ~(in_dataA | in_dataB);              // logical nor
                e_alu_mode'(13) : alu_result = ~(in_dataA ^ in_dataB);              // logical xnor
                e_alu_mode'(14) : alu_result = (in_dataA > in_dataB)? 8'd1 : 8'd0;  // greater comparison
                e_alu_mode'(15) : alu_result = (in_dataA == in_dataB)? 8'd1 : 8'd0; // equal comparison
                default         : alu_result = in_dataA + in_dataB;
            endcase
        end
        else begin
            alu_result = '0;
        end
    end : alumodes

    assign out_data = alu_result;
    assign tmp = {1'b0,in_dataA} + {1'b0,in_dataB};
    assign out_cout = tmp[8];

endmodule