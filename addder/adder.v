module CarryLookaheadAdder(
        input wire[3:0] a,
        input wire[3:0] b,
        input wire c0,
        output wire[3:0] res,
        output wire carry
    );
endmodule

module adder(
        input wire[15:0] a,
        input wire[15:0] b,
        output wire[15:0] res,
        output wire carry
    );
    wire[2:0] c;
    CarryLookaheadAdder sub_adder1(a[3:0], b[3:0], 1'b0, res[3:0], c[0]);
    CarryLookaheadAdder sub_adder2(a[7:4], b[7:4], c[0], res[7:4], c[1]);
    CarryLookaheadAdder sub_adder3(a[11:8], b[11:8], c[1], res[11:8], c[2]);
    CarryLookaheadAdder sub_adder4(a[15:12], b[15:12], c[2], res[15:12], carry);
endmodule
