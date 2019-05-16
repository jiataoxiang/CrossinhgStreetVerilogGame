module entrance(
		input resetn,clock, EN,
		output plot,finish,
		output reg [7:0]x,
		output reg [6:0]y,
		output [2:0]colour_out);
	wire b1,b2,b3,b4;
	wire [7:0]x1,x2,x3,x4;
	wire [6:0]y1,y2,y3,y4;
	wire finish_draw_b1,finish_draw_b2, finish_draw_b3,finish_draw_b4;
	//datapath
	datapathentrance d0(
	.resetn(resetn), 
	.clock(clock),
	.b1(b1),.b2(b2),.b3(b3),.b4(b4),
	
	.x1(x1),.x2(x2),.x3(x3),.x4(x4),
	.y1(y1),.y2(y2),.y3(y3),.y4(y4),
	.colour_out(colour_out),
	.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),
	.finish_draw_b3(finish_draw_b3),.finish_draw_b4(finish_draw_b4));
	// assign colour
	
	wire enb1,enb2, enb3,enb4;
	//control
	FSMentrance f0(
	.clock(clock), .resetn(resetn), .EN(EN),
	.enb1(enb1),.enb2(enb2),.enb3(enb3),.enb4(enb4),
	.b1(b1),.b2(b2),.b3(b3),.b4(b4), .plot(plot), .finish(finish),
	.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),
	.finish_draw_b3(finish_draw_b3),.finish_draw_b4(finish_draw_b4));
	
	always @(*)
	begin
		if (enb1 == 1'b1)begin
			x = x1;
			y = y1;
			end
		else if (enb2 == 1'b1)begin
			x = x2;
			y = y2;
			end
		else if (enb3 == 1'b1)begin
			x = x3;
			y = y3;
			end
		else if (enb4 == 1'b1)begin
			x = x4;
			y = y4;
			end
	end
		
endmodule


module datapathentrance(
	input resetn, clock,
	input  b1,b2,b3,b4,
	output [7:0]x1,x2,x3,x4,
	output [6:0]y1,y2,y3,y4,
	output reg [2:0] colour_out,
	output finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4);
//assign colour
	always @(posedge clock)
	begin
		if (resetn == 1'b0)
			colour_out = 3'b000;
		else if (b1)
			colour_out = 3'b100;
		else if (b2)begin
			if (q1 <= 6'b000110)
				colour_out = 3'b100;
			else
				colour_out = 3'b000;
		end
		else if (b3)begin
			if (q3 == 2'b11)
				colour_out = 3'b010;
			else
				colour_out = 3'b110;
			end
		else if (b4)
			colour_out = 3'b010;
		else
			colour_out = 3'b100;
	end
	
	
	//draW_B1
	reg [7:0]q;
	reg [5:0]q1;
	always @(posedge clock)
	begin
		if (!resetn)
			q <= 8'd0;
		else if (q == 8'b11111111)
			q <= 8'd0;
		else if (b1 == 1'b1)
			q <= q + 1;
		else
			q <= 6'd0;
	end
	//draW_B2
	always @(posedge clock)
	begin
		if (!resetn)
			q1 <= 6'd0;
		else if (q1 == 6'b111111)
			q1 <= 6'd0;
		else if (b2 == 1'b1)
			q1 <= q1 + 1;
		else
			q1 <= 6'd0;
	end
	assign x1 = q[3:0];
	assign y1 = q[7:4];
	assign x2 = 4 + q1[2:0];
	assign y2 = 4 + q1[5:3];
	assign finish_draw_b1 = (q == 8'b11111111)? 1:0;
	assign finish_draw_b2 = (q1 == 6'b111111)? 1:0;
	
	
	reg [1:0]q3,q4;
	//draW_B3
	always @(posedge clock)
	begin
		if (!resetn)
			q3 <= 2'd0;
		else if (q1 == 2'b11)
			q3 <= 2'd0;
		else if (b3 == 1'b1)
			q3 <= q3 + 1;
		else
			q3 <= 2'd0;
	end
	
	//draW_B4
	always @(posedge clock)
	begin
		if (!resetn)
			q4 <= 2'd0;
		else if (q4 == 2'b11)
			q4 <= 2'd0;
		else if (b4 == 1'b1)
			q4 <= q4 + 1;
		else
			q4 <= 2'd0;
	end
	assign x3 = 8'd133 + q3[0];
	assign y3 = 8'd102 + q3[1];
	assign x4 = 8'd133 + q4[0];
	assign y4 = 8'd21 + q4[1];
	assign finish_draw_b3 = (q3 == 2'b11)? 1:0;
	assign finish_draw_b4 = (q4 == 2'b11)? 1:0;

endmodule

module FSMentrance (
	input clock, resetn,finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4, EN,
	output reg enb1, enb2,enb3, enb4, b1, b2,b3, b4, plot, finish);

reg [3:0] current_state, next_state;
	
	localparam 
				Begin   = 4'd0,
				WAIT    = 4'd1,
				DRAW_B1 = 4'd2,
				DRAW_B2 = 4'd3,
				DRAW_B3 = 4'd4,
				DRAW_B4 = 4'd5;
					

	always @(*)
	begin: state_table
		case (current_state)
			Begin: next_state = EN? DRAW_B1 : Begin;
			DRAW_B1: next_state = finish_draw_b1? DRAW_B2 : DRAW_B1;
			DRAW_B2: next_state = finish_draw_b2? DRAW_B3 : DRAW_B2;
			DRAW_B3: next_state = finish_draw_b3? DRAW_B4 : DRAW_B3;
			DRAW_B4: next_state = finish_draw_b4? WAIT : DRAW_B4;
			WAIT: next_state = Begin;
			default: next_state = Begin;
		endcase
	end
	
	always @(*)
	begin: signals
		plot = 1'b0;
		enb1 = 1'b0;
		enb2 = 1'b0;
		enb3 = 1'b0;
		enb4 = 1'b0;
		b1 = 1'b0;
		b2 = 1'b0;
		b3 = 1'b0;
		b4 = 1'b0;
		finish = 1'b0;
		
		case (current_state)
		Begin:begin
		
		end
		DRAW_B1:begin
			b1 = 1'b1;
			enb1 = 1'b1;
			plot = 1'b1;
		end
		DRAW_B2:begin
			b2 = 1'b1;
			enb2 = 1'b1;
			plot = 1'b1;
		end
		DRAW_B3:begin
			b3 = 1'b1;
			enb3 = 1'b1;
			plot = 1'b1;
		end
		DRAW_B4:begin
			b4 = 1'b1;
			enb4 = 1'b1;
			plot = 1'b1;
		end
		WAIT:begin
			finish = 1'b1;
		end
		
		endcase
	end
	
	
always@(posedge clock)
    begin: state_FFs
        if(!resetn)
            current_state <= Begin;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
