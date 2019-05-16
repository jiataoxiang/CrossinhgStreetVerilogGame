module motocar10(
		input [2:0] colour,
		input resetn,
		input clk,
		input EN,
		input right, down,
		output plot,
		output finish_F1,
		output [7:0]x,
		output [6:0]y,
		output [2:0]colour_out,
		output [7:0]x_ori,
		output [6:0]y_ori
		);
	
	
	wire draw;
	wire en_xy, en_delay, erase_colour, finish_draw, finish_erase;
	datapathcar10 D1(
			.colour(colour),
			.clk(clk),
			.resetn(resetn),
			.en_xy(en_xy), 
			.en_delay(en_delay),
			.erase_colour(erase_colour), 
			.draw(draw), 
			.right(right),
			.down(down),
			.finish_draw(finish_draw),
			.finish_erase(finish_erase),
			.x(x),
			.y(y),
			.colour_out(colour_out),
			.x_ori(x_ori),
			.y_ori(y_ori));
	FSMcar10 F1(
			.clk(clk), 
			.resetn(resetn),
			.finish_draw(finish_draw),
			.finish_erase(finish_erase),
			.EN(EN),
			.en_xy(en_xy), 
			.en_delay(en_delay), 
			.erase_colour(erase_colour), 
			.draw(draw),
			.finish_F1(finish_F1),
			.plot(plot),
			.x(x),
			.y(y));
			
		
endmodule

module datapathcar10(
			input [2:0]colour,
			input clk,
			input resetn,
			input en_xy, en_delay,erase_colour, draw, right,down,
			output finish_draw,
			output reg finish_erase,
			output reg [7:0]x,
			output reg [6:0]y,
			output reg [2:0]colour_out,
			output [7:0]x_ori,
			output [6:0]y_ori);
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
				else if (q == 20'd8333)
					q <= 20'd0;
				else 
				begin
					if (en_delay == 1'b1)
						q <= q + 1'b1;
				end
			end
			//frame counter
			wire en_frame;
			assign en_frame = (q == 20'd8333)? 1:0;
			
			reg [3:0]frame;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)
					frame <= 4'b0000;
				else if (frame == 4'd2)
					frame <= 4'b0000;
				else
				begin
					if (en_frame == 1'b1)
						frame <= frame + 1'b1;
				end
			end
			
			assign finish_draw = (frame == 4'd2)? 1:0;
			//x counter
			reg [7:0]x_original;
			reg [6:0]y_original;
			assign x_ori = x_original;
			assign y_ori = y_original;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)begin
					x_original <= 8'd60;
					y_original <= 7'd91;
					end
				else if (en_xy == 1'b1)
				begin
					if (right && down)begin
						x_original <= x_original + 1'b1;
						y_original <= y_original + 1'b1;
						end
					else if (!right && down)begin
						x_original <= x_original - 1'b1;
						y_original <= y_original + 1'b1;
						end
					else if (right && !down)begin
						x_original <= x_original + 1'b1;
						y_original <= y_original - 1'b1;
						end
					else begin
						x_original <= x_original - 1'b1;
						y_original <= y_original - 1'b1;
						end
						
				end
			end
			
			//draw box
			reg [1:0]q2;
			always @(posedge clk)
			begin
				if (resetn == 1'b0)begin
					q2 <= 2'd0;
					finish_erase <= 1'b0;
					end
				else if (finish_draw)
					q2 <= 2'd0;
				else if (draw)
				begin
					if (q2 == 2'b11)begin
						q2 <= 2'd0;
						finish_erase <= 1'b1;
						end
					else begin
						q2 <= q2 + 1'b1;
						finish_erase <= 1'b0;
						end
				end
				else
					q2 <= 2'd0;
					
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
					x = x_original + q2[1:0];
					y = y_original;
				end
			end

endmodule

module FSMcar10(
			input clk, resetn,finish_draw,finish_erase,EN,
			output reg en_xy, en_delay, erase_colour, draw,finish_F1,plot,
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

	
			always@(posedge clk)
			begin: state_FFs
				if(!resetn)
					current_state <= WAIT;
				else
					current_state <= next_state;
			end // state_FFS

endmodule