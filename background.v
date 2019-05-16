module background(
		input resetn,clock, EN,
		output plot,finish,
		output reg [7:0]x,
		output reg [6:0]y,
		output [2:0]colour_out);
	wire h1,h2,v1,v2,b1;
	wire [7:0]x_h1, x_h2, x_v1, x_v2,x1;
	wire [6:0]y_h1, y_h2, y_v1, y_v2,y1;
	wire finish_draw_h1, finish_draw_h2, finish_draw_v1,finish_draw_v2,finish_draw1;
	//datapath
	datapath3 d0(
	.resetn(resetn), 
	.clock(clock),
	.h1(h1),.h2(h2),.v1(v1),.v2(v2),.b1(b1),
	
	.x_h1(x_h1),.x_h2(x_h2),.x_v1(x_v1),.x_v2(x_v2),.x1(x1),
	.y_h1(y_h1), .y_h2(y_h2), .y_v1(y_v1),.y_v2(y_v2),.y1(y1),
	.colour_out(colour_out),.finish_draw_h1(finish_draw_h1), .finish_draw_h2(finish_draw_h2), 
	.finish_draw_v1(finish_draw_v1),.finish_draw_v2(finish_draw_v2),.finish_draw1(finish_draw1));
	// assign colour
	
	wire enh1,enh2,env1,env2,enb1;
	//control
	FSM3 f0(
	.clock(clock), .resetn(resetn), .EN(EN),
	.enh1(enh1), .enh2(enh2),.env1(env1),.env2(env2),.enb1(enb1),.h1(h1),.h2(h2),
	.v1(v1),.v2(v2),.b1(b1), .plot(plot), .finish(finish),
	.finish_draw_h1(finish_draw_h1),.finish_draw_h2(finish_draw_h2),
	.finish_draw_v1(finish_draw_v1),.finish_draw_v2(finish_draw_v2),.finish_draw1(finish_draw1));
	
	always @(*)
	begin
		if (enh1 == 1'b1)begin
			x = x_h1;
			y = y_h1;
			end
		else if (enh2 == 1'b1)begin
			x = x_h2;
			y = y_h2;
			end
		else if (env1 == 1'b1)begin
			x = x_v1;
			y = y_v1;
				end
		else if (env2 == 1'b1)begin
			x = x_v2;
			y = y_v2;
			end
		else if (b1)begin
			x = x1;
			y = y1;
			end
	end
		
endmodule


module datapath3(
	input resetn, clock,
	input  h1,h2,v1,v2,b1,
	
	output reg [7:0]x_h1,x_h2,x_v1,x_v2,
	output reg [6:0]y_h1, y_h2, y_v1,y_v2,
	output [7:0]x1,
	output [6:0]y1,
	output reg [2:0] colour_out,
	output finish_draw_h1, finish_draw_h2, finish_draw_v1,finish_draw_v2,finish_draw1);
//assign colour
	always @(posedge clock)
	begin
		if (resetn == 1'b0)
			colour_out = 3'b000;
		else if (b1)
			colour_out = 3'b100;
		else
			colour_out = 3'b100;
	end
	
// horizontal line
	always @(posedge clock)
	begin
		if (!resetn)begin
			x_h1 = 8'd25;
			y_h1 = 7'd20;
			end
		else if (x_h1 == 8'd135)
			x_h1 = 8'd25;
		else 
		begin
			if (h1 == 1'b1)
				x_h1 = x_h1 + 1'b1;
		end
	end
	assign finish_draw_h1 = (x_h1 == 8'd135)? 1 : 0;
	//horizontal line2
	always @(posedge clock)
	begin
		if (!resetn)begin
			x_h2 = 8'd25;
			y_h2 = 7'd104;
			end
		else if (x_h2 == 8'd135)
			x_h2 = 8'd25;
		else 
		begin
			if (h2 == 1'b1)
				x_h2 = x_h2 + 1'b1;
		end
	end
	assign finish_draw_h2 = (x_h2 == 8'd135)? 1 : 0;
	// vertical line
	always @(posedge clock)
	begin
		if (!resetn)begin
			x_v1 = 8'd25;
			y_v1 = 7'd20;
			end
		else if (y_v1 == 7'd104)
			y_v1 = 8'd20;
		else 
		begin
			if (v1 == 1'b1)
				y_v1 = y_v1 + 1'b1;
		end
	end
	assign finish_draw_v1 = (y_v1 == 7'd104)? 1:0;
	// vertical line2
	always @(posedge clock)
	begin
		if (!resetn)begin
			x_v2 = 8'd135;
			y_v2 = 7'd20;
			end
		else if (y_v2 == 7'd104)
			y_v2 = 7'd20;
		else 
		begin
			if (v2 == 1'b1)
				y_v2 = y_v2 + 1'b1;
		end
	end
	assign finish_draw_v2 = (y_v2 == 7'd104)? 1:0;
	// drawb1
	reg [1:0]q1;
	always@(posedge clock)
	begin
		if (!resetn)begin
			q1 <= 2'd0;
			end
		else if (q1 == 2'b11)
			q1 <= 2'd0;
		else if (b1)
			q1 <= q1 + 1'b1;
		else
			q1 <= 2'd0;
	end
	assign x1 = 8'd133 + q1[0];
	assign y1 = 7'd21 + q1[1];
	assign finish_draw1 = (q1 == 2'b11)? 1:0;

endmodule

module FSM3 (
	input clock, resetn,finish_draw_h1,finish_draw_h2,finish_draw_v1,finish_draw_v2,finish_draw1, EN,
	output reg enh1, enh2,env1,env2,enb1, h1,h2,v1,v2,b1, plot, finish);

reg [3:0] current_state, next_state;
	
	localparam 
				Begin   = 4'd0,
				DRAW_h1 = 4'd1,
				DRAW_h2 = 4'd2,
				DRAW_v1 = 4'd3,
				DRAW_v2 = 4'd4,
				DRAW_b1 = 4'd6,
				WAIT    = 4'd5;
					

	always @(*)
	begin: state_table
		case (current_state)
			Begin: next_state = EN? DRAW_h1 : Begin;
			DRAW_h1: next_state = finish_draw_h1? DRAW_h2 : DRAW_h1;
			DRAW_h2: next_state = finish_draw_h2? DRAW_v1 : DRAW_h2;
			DRAW_v1: next_state = finish_draw_v1? DRAW_v2 : DRAW_v1;
			DRAW_v2: next_state = finish_draw_v2? DRAW_b1 : DRAW_v2;
			DRAW_b1: next_state = finish_draw1? WAIT : DRAW_b1;
			WAIT: next_state = Begin;
			default: next_state = Begin;
		endcase
	end
	
	always @(*)
	begin: signals
		plot = 1'b0;
		enh1 = 1'b0;
		enh2 = 1'b0;
		env1 = 1'b0;
		env2 = 1'b0;
		enb1 = 1'b0;
		h1 = 1'b0;
		h2 = 1'b0;
		v1 = 1'b0;
		v2 = 1'b0;
		b1 = 1'b0;
		finish = 1'b0;
		
		case (current_state)
		Begin:begin
		
		end
		DRAW_h1:begin
			h1 = 1'b1;
			enh1 = 1'b1;
			plot = 1'b1;
		end
		DRAW_h2:begin
			h2 = 1'b1;
			enh2 = 1'b1;
			plot = 1'b1;
		end
		DRAW_v1:begin
			v1 = 1'b1;
			env1 = 1'b1;
			plot = 1'b1;
		end
		DRAW_v2:begin
			v2 = 1'b1;
			env2 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b1:begin
			b1 = 1'b1;
			enb1 = 1'b1;
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
