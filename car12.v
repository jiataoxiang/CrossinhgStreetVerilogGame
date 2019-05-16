module car12(
		input [2:0] colour,
		input resetn,
		input clk,
		input EN,
		output plot,
		output finish_F3,
		output [7:0]x,
		output [6:0]y,
		output [2:0]colour_out,
		output [7:0]x_ori);
	
	
	wire draw;
	wire en_xy, en_delay, erase_colour, finish_draw, finish_erase, right;
	datapath12 D1(
			.colour(colour),
			.clk(clk),
			.resetn(resetn),
			.en_xy(en_xy), 
			.en_delay(en_delay),
			.erase_colour(erase_colour), 
			.draw(draw), 
			.right(right),
			.finish_draw(finish_draw),
			.finish_erase(finish_erase),
			.x(x),
			.y(y),
			.colour_out(colour_out),
			.x_ori(x_ori));
	FSM12 F1(
			.clk(clk), 
			.resetn(resetn),
			.finish_draw(finish_draw),
			.finish_erase(finish_erase),
			.EN(EN),
			.en_xy(en_xy), 
			.en_delay(en_delay), 
			.erase_colour(erase_colour), 
			.draw(draw), 
			.right(right),
			.finish_F1(finish_F3),
			.plot(plot),
			.x(x),
			.y(y));
		
endmodule

module datapath12(
			input [2:0]colour,
			input clk,
			input resetn,
			input en_xy, en_delay,erase_colour, draw, right,
			output finish_draw,
			output reg finish_erase,
			output reg [7:0]x,
			output reg [6:0]y,
			output reg [2:0]colour_out,
			output [7:0]x_ori);
			//colour reg
			always @(*)
			begin
				if (resetn == 1'b0)
					colour_out <= 3'b000;
				else
				begin
					if (erase_colour == 1'b1)
						colour_out <= 3'b000;
					else
						colour_out <= colour;
				end
			end
			
			//rate dividor, delay counter
			reg [19:0]q;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)
					q <= 20'd0;
				else if (q == 20'd83)
					q <= 20'd0;
				else 
				begin
					if (en_delay == 1'b1)
						q <= q + 1'b1;
				end
			end
			//frame counter
			wire en_frame;
			assign en_frame = (q == 20'd83)? 1:0;
			
			reg [3:0]frame;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)
					frame <= 4'b0000;
				else if (frame == 4'd5)
					frame <= 4'b0000;
				else
				begin
					if (en_frame == 1'b1)
						frame <= frame + 1'b1;
				end
			end
			
			assign finish_draw = (frame == 4'd5)? 1:0;
			//x counter
			reg [7:0]x_original;
			reg [6:0]y_original;
			assign x_ori = x_original;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)begin
					x_original <= 8'd62;
					y_original <= 7'd75;
					end
				else if (en_xy == 1'b1)
				begin
					if (x_original == 8'd127)
						x_original <= 8'd26;
					else
						x_original <= x_original + 1'b1;
				end
			end
			
			//draw box
			reg [4:0]q2;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)begin
					q2 <= 5'b00000;
					finish_erase <= 1'b0;
					end
				else if (finish_draw)
					q2 <= 5'b00000;
				else if (draw)
				begin
					if (q2 == 5'b11111)begin
						q2 <= 5'b00000;
						finish_erase <= 1'b1;
						end
					else begin
						q2 <= q2 + 1'b1;
						finish_erase <= 1'b0;
						end
				end
					
			end
			
			// xy coordinate
			always @(*)
			begin
				if (!resetn) begin
					x = x_original;
					y = y_original;
				end
				else if(draw)
				begin
					x = x_original + q2[2:0];
					y = y_original + q2[4:3];
				end
			end

endmodule

module FSM12(
			input clk, resetn,finish_draw,finish_erase,EN,
			output reg en_xy, en_delay, erase_colour, draw, right,finish_F1,plot,
			input [7:0]x,
			input [6:0]y);
			
			reg [2:0] current_state, next_state;

			localparam  ERASE= 3'd0,
							NEW_XY = 3'd1,
							DRAW = 3'd2,
							WAIT = 3'd3;
			always @(*)
			begin: state_table
				case (current_state)
					WAIT: next_state = EN? ERASE: WAIT;
					ERASE: next_state = finish_erase ? NEW_XY : ERASE;
					NEW_XY: next_state = DRAW;
					DRAW: next_state = finish_draw ?  WAIT: DRAW;
					default: next_state = WAIT;
				endcase
			end
			
			always @(*)
			begin: signals
				en_xy = 1'b0; 
				en_delay = 1'b0;
				erase_colour = 1'b0;
				draw = 1'b0;
				plot = 1'b0;
				finish_F1 = finish_draw;
		
				case (current_state)
					DRAW: begin
					en_delay = 1'b1;
					erase_colour = 1'b0;
					draw = 1'b1;
					plot = 1'b1;
						end
					ERASE: begin
					erase_colour = 1'b1;
					draw = 1'b1;
					plot = 1'b1;
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
			//direction
//			always @(posedge clk)
//			begin
//				if(!resetn)
//					right <= 1'b1;
//				else
//				begin
//					if (x == 8'd26)
//						right <= 1'b1;
//					if (x == 8'd133)
//						right <= 1'b0;
//				end	
//			end
	
			always@(posedge clk)
			begin: state_FFs
				if(!resetn)
					current_state <= WAIT;
				else
					current_state <= next_state;
			end // state_FFS

endmodule
