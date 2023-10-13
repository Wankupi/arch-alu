module float_adder
	(input wire clk,
	 input wire rst,
	 input wire valid,
	 input wire[31:0] x,
	 input wire[31:0] y,
	 output wire [31:0] z
	);

	parameter Start = 3'b000, ZeroCheck = 3'b001, EqualExp= 3'b010, AddM = 3'b011, Normal = 3'b100, Done = 3'b101;
	reg[2:0] state;

	reg signx, signy, signz;
	reg[7:0] expx, expy, expz;
	reg[24:0] mx, my, mz;

	assign z = {signz, expz[7:0], mz[22:0]};

	always @(posedge clk) begin
		if (rst) begin
			state <= Start;
		end
		else begin
			case(state)
				Start: begin
					if (valid) begin
						signx <= x[31];
						expx <= x[30:23];
						mx <= {1'b0, 1'b1, x[22:0]};
						signy <= y[31];
						expy <= y[30:23];
						my <= {1'b0, 1'b1, y[22:0]};

						if ((expx == 8'd255 && mx[22:0] != 0) || (expy == 8'd255 && my[22:0] != 0)) begin
							// nan
							signz <= 1'b0;
							expz <= 8'd255;
							mx <= 23'h7fffff;
							state <= Done;
						end
						else if ((expx == 8'd255 && mx[22:0] == 0) || (expy == 8'd255 && my[22:0] == 0)) begin
							// inf
							signz <= 1'b0;
							expz <= 8'd255;
							mx <= 23'b0;
							state <= Done;
						end
						else begin
							state <= ZeroCheck;
						end
					end
					// else keep state
				end

				ZeroCheck: begin
					if (mx[22:0] == 23'b0 && expx == 8'b0) begin
						{signz, expz, mz} <= {signy, expy, my};
						state <= Done;
					end
					else if (my[22:0] == 23'b0 && expy == 8'b0) begin
						{signz, expz, mz} <= {signx, expx, mx};
						state <= Done;
					end
					else begin
						state <= EqualExp;
					end
				end

				EqualCheck: begin

				end


				Addm: begin

				end

				Normal: begin

				end

				Done: begin

				end
			endcase
		end
	end
endmodule //float_adder
