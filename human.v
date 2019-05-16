module human(
		input [2:0] colour,
		input resetn,
		input clk,
		input EN, left, right, up, down,
		output plot,
		output finish_P,
		output [7:0] x,
		output [6:0] y,
		output [7:0] x_ori,
		output [6:0] y_ori,
		output [2:0] colour_out);
	
//	wire [7:0] input_x;
//	wire [6:0] input_y;
	wire draw;
	wire en_xy, erase_colour, finish_draw, finish_erase;
	
	
	locationCounter l1(.resetn(resetn), 
						.clock(clk), 
						.en_move(en_xy), 
						.left(left), 
						.right(right), 
						.up(up), 
						.down(down), 
						.x_out(x_ori), 
						.y_out(y_ori));
						
	drawPeople d1(.clock(clk), 
					.resetn(resetn), 
					.enable(draw), 
					.erase(erase_colour), 
					.input_x(x_ori), 
					.input_y(y_ori), 
					.colour(colour),  
					.output_x(x), 
					.output_y(y), 
					.colour_out(colour_out), 
					.finish_draw(finish_draw),
					.finish_erase(finish_erase),
					.plot(plot));
	
	FSMPeople f1(.clk(clk), 
				.resetn(resetn),
				.finish_draw(finish_draw), 
				.finish_erase(finish_erase),
				.EN(EN), 
				.en_xy(en_xy), 
				.erase_colour(erase_colour), 
				.en_draw(draw), 
				.finish_Fp(finish_P));
			
		
endmodule

module locationCounter(resetn, clock, en_move, left, right, up, down, x_out, y_out);
	input resetn, clock, en_move, left, right, up, down;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	
	//x counter
	always@(posedge clock)
	begin 
		if(!resetn)
			x_out <= 8'd5;
		else if(en_move)
		begin
			if(x_out == 8'd133)//set boundary
			begin
				if(left)
					x_out <= x_out - 1'b1;
				else
					x_out <= x_out;
			end
			else if(x_out == 8'd26)//set boundary
			begin
				if(right)
					x_out <= x_out + 1'b1;
				else
					x_out <= x_out;
			end
			else
			begin
				if(left)
					x_out <= x_out - 1'b1;
				else if(right)
					x_out <= x_out + 1'b1;
				else
					x_out <= x_out;
			end
		end
		
	//y counter
		if(!resetn)
			y_out <= 7'd7;
		else if(en_move)
		begin
			if(y_out == 8'd9 || y_out == 8'd5 || x_out == 8'd9 || x_out == 8'd4)//set boundary
				begin
					x_out <= 8'd26;
					y_out <= 8'd21;
				end
			else if(y_out == 8'd102)//set boundary
			begin
				if(up)
					y_out <= y_out - 1'b1;
				else
					y_out <= y_out;
			end
			else if(y_out == 8'd21)//set boundary
			begin
				if(down)
					y_out <= y_out + 1'b1;
				else
					y_out <= y_out;
			end
			else
			begin
				if(up)
					y_out <= y_out - 1'b1;
				else if(down)
					y_out <= y_out + 1'b1;
				else
					y_out <= y_out;
			end
		end
		
	end
endmodule




module drawPeople(clock, resetn, enable, erase, input_x, input_y, colour,  output_x, output_y, colour_out, finish_draw, finish_erase, plot);
	input resetn, clock, enable, erase;
	input [7:0] input_x;
	input [6:0] input_y;
	input [2:0] colour;
	output reg finish_draw, finish_erase, plot;
	output reg [7:0] output_x;
	output reg [6:0] output_y;
	output reg [2:0] colour_out;
	
	always @(posedge clock)
	begin: load_register
		if (!resetn) begin
			colour_out <= 3'b000;
			end
		else 
			begin
				if (erase)
					colour_out <= 3'b000;
				else
					colour_out <= colour;
			end
	end
	
	
	reg [2:0] q2;
	//draw count
	always @(posedge clock)
	begin: counter
		if (!resetn) begin
			q2 <= 3'b000;
			finish_draw <= 1'b0;
			finish_erase <= 1'b0;
			plot <= 1'b0;
			end
		else if (enable)
			begin
				if (q2 == 3'b111) begin
					q2 <= 3'b000;
					finish_draw <= 1'b1;
					finish_erase <= 1'b1 & erase;
					plot <= 1'b0;
					end
				else begin
					q2<= q2 + 1'b1;
					finish_draw <= 1'b0;
					finish_erase <= 1'b0;
					plot <= 1'b1;
					end
			end
	end
	
	
	reg [1:0] q;
	//draw
	always @(posedge clock)
	begin: counter_draw
		if (!resetn) begin
			q <= 2'b00;
			end
		else if (enable)
			begin
				if (q == 2'b11) begin
					q <= 2'b00;
					end
				else begin
					q <= q + 1'b1;
					end
			end
	end
	
	always @(*)
	begin
		if (!resetn) begin
			output_x = input_x;
			output_y = input_y;
		end
		else if(enable)
			begin
				output_x = input_x + q[0];
				output_y = input_y + q[1];
			end
	end
endmodule
	

module FSMPeople(
			input clk, resetn,finish_draw, finish_erase, EN,
			output reg en_xy, erase_colour, en_draw, finish_Fp);
			
			reg [2:0] current_state, next_state;

			localparam  ERASE= 3'd0,
							NEW_XY = 3'd1,
							DRAW = 3'd2,
							WAIT = 3'd3;
			always @(*)
			begin: state_table
				case (current_state)
					WAIT: next_state = EN ? ERASE : WAIT;
					ERASE: next_state = finish_erase ? NEW_XY : ERASE;
					NEW_XY: next_state = DRAW;
					DRAW: next_state = finish_draw ?  WAIT: DRAW;
					default: next_state = WAIT;
				endcase
			end
			
			always @(*)
			begin: signals
				en_xy = 1'b0;
				erase_colour = 1'b0;
				en_draw = 1'b0;
				finish_Fp = finish_draw & ~finish_erase;
		
				case (current_state)
					DRAW: begin
					en_draw = 1'b1;
						end
					ERASE: begin
					erase_colour = 1'b1;
					en_draw = 1'b1;
					end
					NEW_XY :
					begin
					en_xy = 1'b1;
					end
					WAIT :
					begin
					end
				endcase
			end
	
			always@(posedge clk)
			begin: state_FFs
				if(!resetn)
					current_state <= ERASE;
				else
					current_state <= next_state;
			end // state_FFS

endmodule