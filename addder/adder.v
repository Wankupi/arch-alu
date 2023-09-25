module CarryLookaheadAdder(
        input wire[3:0] a,
        input wire[3:0] b,
        input wire c0,
        output wire[3:0] sum,
        output wire carry
    );
    wire [3:0] c;
    wire[3:0] G = a & b;
    wire[3:0] P = a ^ b;
    assign c[0] = c0;
    assign sum = P ^ c;

    assign c[1] = G[0] | (c[0] & P[0]);
    assign c[2] = G[1] | (P[1] & G[0]) | (c[0] & P[0] & P[1]);
    assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (c[0] & P[0] & P[1] & P[2]);
    assign carry = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (c[0] & P[0] & P[1] & P[2] & P[3]);
endmodule

module adder16(
        input wire[15:0] a,
        input wire[15:0] b,
        input wire c0,
        output wire[15:0] sum,
        output wire carry
    );
    wire[3:1] c;
    CarryLookaheadAdder sub_adder0(a[3:0], b[3:0], c0, sum[3:0], c[1]);
    CarryLookaheadAdder sub_adder1(a[7:4], b[7:4], c[1], sum[7:4], c[2]);
    CarryLookaheadAdder sub_adder2(a[11:8], b[11:8], c[2], sum[11:8], c[3]);
    CarryLookaheadAdder sub_adder3(a[15:12], b[15:12], c[3], sum[15:12], carry);
endmodule

module adder32(
        input wire[31:0] a,
        input wire[31:0] b,
        input wire c0,
        output wire[31:0] sum,
        output wire carry
    );
    wire c1;
    adder16 sub_adder1(a[15:0], b[15:0], c0, sum[15:0], c1);
    adder16 sub_adder2(a[31:16], b[31:16], c1, sum[31:16], carry);
endmodule

module adder(
        input wire[15:0] a,
        input wire[15:0] b,
        output wire[15:0] sum,
        output wire carry
    );
	wire zero = 0;
    adder16 adder_impl(
                .a(a),
                .b(b),
                .c0(zero),
                .sum(sum),
                .carry(carry)
            );
endmodule

module Add(
        input wire[31:0] a,
        input wire[31:0] b,
        output wire[31:0] sum
    );
    wire zero = 0;
	wire x;
    adder32 adder_impl(a, b, zero, sum, x);
endmodule
