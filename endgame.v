module endgame(
	input resetn, clock, EN,
	output plot, finish, 
	output [7:0]x,
	output [6:0]y,
	output [2:0]colour_out);
	
	// datapath d0(...);
	wire b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11;
	wire reset_data;
	wire finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7,finish_draw_b8,finish_draw_b9,finish_draw_b10,finish_draw_b11;
	datapathe de(
		.b1(b1),.b2(b2),.b3(b3),.b4(b4),.b5(b5),.b6(b6),.b7(b7),.b8(b8),.b9(b9),.b10(b10),.b11(b11),
		.clock(clock), .reset_data(reset_data),
		.x(x),
		.y(y),
		.colour_out(colour_out),
		.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),.finish_draw_b3(finish_draw_b3),
		.finish_draw_b4(finish_draw_b4),.finish_draw_b5(finish_draw_b5),.finish_draw_b6(finish_draw_b6),
		.finish_draw_b7(finish_draw_b7),.finish_draw_b8(finish_draw_b8),.finish_draw_b9(finish_draw_b9),
		.finish_draw_b10(finish_draw_b10),.finish_draw_b11(finish_draw_b11));
	//controller
	FSMe Fe(
		.clock(clock), .resetn(resetn),.EN(EN),
		.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),
		.finish_draw_b3(finish_draw_b3),.finish_draw_b4(finish_draw_b4),
		.finish_draw_b5(finish_draw_b5),
		.finish_draw_b6(finish_draw_b6),.finish_draw_b7(finish_draw_b7),
		.finish_draw_b8(finish_draw_b8),.finish_draw_b9(finish_draw_b9),
		.finish_draw_b10(finish_draw_b10),.finish_draw_b11(finish_draw_b11),
		.b1(b1),.b2(b2),.b3(b3),.b4(b4),.b5(b5),.b6(b6),.b7(b7),.b8(b8),.b9(b9),.b10(b10),.b11(b11), 
		.plot(plot),.finish_draw(finish),.reset_data(reset_data));

endmodule


module datapathe(
		input b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,
		input clock, reset_data,
		output reg [7:0]x,
		output reg [6:0]y,
		output reg [2:0] colour_out,
		output finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7,finish_draw_b8,finish_draw_b9,finish_draw_b10,finish_draw_b11);
	//colour
	always @(posedge clock)
	begin
		if (!reset_data)
			colour_out <= 3'b000;
		else
			colour_out <= 3'b011;
	
	end
	reg [7:0]x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11;
	reg [6:0]y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11;
	

	
	//counter1
	reg [7:0]q1,q2,q3,q4,q5,q7,q8,q9,q10,q11;
	reg [8:0]q6;
	always @(posedge clock)
	begin
		if (!reset_data)
			q1 <= 8'd0;
		else if (q1 == 8'b01100111)
			q1 <= 8'd0;
		else if (b1 == 1'b1)
			q1 <= q1 + 1;
	end
	assign finish_draw_b1 = (q1 == 8'b01100111)? 1:0;
	//counter2
	always @(posedge clock)
	begin
		if (!reset_data)
			q2 <= 8'd0;
		else if (q2 == 8'b01010011)
			q2 <= 8'd0;
		else if (b2 == 1'b1)
			q2 <= q2 + 1;
	end
	assign finish_draw_b2 = (q2 == 8'b01010011)? 1:0;
	//counter3
	always @(posedge clock)
	begin
		if (!reset_data)
			q3 <= 8'd0;
		else if (q3 == 8'b00111111)
			q3<= 8'd0;
		else if (b3 == 1'b1)
			q3 <= q3 + 1;
	end
	assign finish_draw_b3 = (q3 == 8'b00111111)? 1:0;
	//counter4
	always @(posedge clock)
	begin
		if (!reset_data)
			q4 <= 8'd0;
		else if (q4 == 8'd01010011)
			q4 <= 8'd0;
		else if (b4 == 1'b1)
			q4 <= q4 + 1;
	end
	assign finish_draw_b4 = (q4 == 8'd01010011)? 1:0;
	//counter5
	always @(posedge clock)
	begin
		if (!reset_data)
			q5 <= 8'd0;
		else if (q5 == 8'b01100111)
			q5 <= 8'd0;
		else if (b5 == 1'b1)
			q5 <= q5 + 1;
	end
	assign finish_draw_b5 = (q5 == 8'b01100111)? 1:0;
	//counter6
	always @(posedge clock)
	begin
		if (!reset_data)
			q6 <= 9'd0;
		else if (q6 == 9'b101000111)
			q6 <= 9'd0;
		else if (b6 == 1'b1)
			q6 <= q6 + 1;
	end
	assign finish_draw_b6 = (q6 == 9'b101000111)? 1:0;
	//counter7
	always @(posedge clock)
	begin
		if (!reset_data)
			q7 <= 8'd0;
		else if (q7 == 8'b10100011)
			q7 <= 8'd0;
		else if (b7 == 1'b1)
			q7 <= q7 + 1;
	end
	assign finish_draw_b7 = (q7 == 8'b10100011)? 1:0;
	//counter8
	always @(posedge clock)
	begin
		if (!reset_data)
			q8 <= 8'd0;
		else if (q8 == 8'b01010011)
			q8 <= 8'd0;
		else if (b8 == 1'b1)
			q8 <= q8 + 1;
	end
	assign finish_draw_b8 = (q8 == 8'b01010011)? 1:0;
	//counter9
	always @(posedge clock)
	begin
		if (!reset_data)
			q9 <= 8'd0;
		else if (q9 == 8'b01010011)
			q9 <= 8'd0;
		else if (b9 == 1'b1)
			q9 <= q9 + 1;
	end
	assign finish_draw_b9 = (q9 == 8'b01010011)? 1:0;
	//counter10
	always @(posedge clock)
	begin
		if (!reset_data)
			q10 <= 8'd0;
		else if (q10 == 8'b01010011)
			q10 <= 8'd0;
		else if (b10 == 1'b1)
			q10 <= q10 + 1;
	end
	assign finish_draw_b10 = (q10 == 8'b01010011)? 1:0;
	//counter11
	always @(posedge clock)
	begin
		if (!reset_data)
			q11 <= 8'd0;
		else if (q7 == 8'b10100011)
			q11 <= 8'd0;
		else if (b11 == 1'b1)
			q11 <= q11 + 1;
	end
	assign finish_draw_b11 = (q11 == 8'b10100011)? 1:0;
	
	//x,y value
	always @(*)
	begin
		if (b1)begin
			x = 8'd40 + q1[1:0];
			y = 7'd40 + q1[7:2];
			end
		else if (b2)begin
			x = 8'd44 + q2[1:0];
			y = 7'd60 + q2[7:2];
			end
		else if (b3)begin
			x = 8'd48 + q3[1:0];
			y = 7'd50 + q3[7:2];
			end
		//set original value
		else if (b4)begin
			x = 8'd52 + q4[1:0];
			y = 7'd60 + q4[7:2];
			end
		else if (b5)begin
			x = 8'd56 + q5[1:0];
			y = 7'd40 + q5[7:2];
			end
		else if (b6)begin
			x = 8'd70 + q6[2:0];
			y = 7'd40 + q6[8:3];
			end
		else if (b7)begin
			x = 8'd88 + q7[1:0];
			y = 7'd40 + q7[7:2];
			end
		else if (b8)begin
			x = 8'd92 + q8[1:0];
			y = 7'd40 + q8[7:2];
			end
		else if (b9)begin
			x = 8'd96 + q9[1:0];
			y = 7'd50 + q9[7:2];
			end
		else if (b10)begin
			x = 8'd100 + q10[1:0];
			y = 7'd60 + q10[7:2];
			end
		else if (b11)begin
			x = 8'd104 + q11[1:0];
			y = 7'd40 + q11[7:2];
			end
	end


endmodule



module FSMe (
	input clock, resetn,EN,finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7,finish_draw_b8,finish_draw_b9,finish_draw_b10,finish_draw_b11,
	output reg enb1, enb2,enb3,enb4,enb5,enb6, enb7,enb8,enb9,enb10,enb11, b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11, plot, finish_draw,reset_data);

	reg [4:0] current_state, next_state;
	
	localparam DRAW_b1 = 5'd0,
				DRAW_b2 = 5'd1,
				DRAW_b3 = 5'd2,
				DRAW_b4 = 5'd3,
				DRAW_b5 = 5'd4,
				DRAW_b6 = 5'd5,
				DRAW_b7 = 5'd6,
				DRAW_b8 = 5'd7,
				DRAW_b9 = 5'd8,
				DRAW_b10 = 5'd9,
				DRAW_b11 = 5'd10,
				WAIT = 5'd11,
				Begin = 5'd12;
					

	always @(*)
	begin: state_table
		case (current_state)
			Begin: next_state = EN? DRAW_b1 : Begin;
			DRAW_b1: next_state = finish_draw_b1? DRAW_b2 : DRAW_b1;
			DRAW_b2: next_state = finish_draw_b2? DRAW_b3 : DRAW_b2;
			DRAW_b3: next_state = finish_draw_b3? DRAW_b4 : DRAW_b3;
			DRAW_b4: next_state = finish_draw_b4? DRAW_b5 : DRAW_b4;
			DRAW_b5: next_state = finish_draw_b5? DRAW_b6 : DRAW_b5;
			DRAW_b6: next_state = finish_draw_b6? DRAW_b7 : DRAW_b6;
			DRAW_b7: next_state = finish_draw_b7? DRAW_b8 : DRAW_b7;
			DRAW_b8: next_state = finish_draw_b8? DRAW_b9 : DRAW_b8;
			DRAW_b9: next_state = finish_draw_b9? DRAW_b10 : DRAW_b9;
			DRAW_b10: next_state = finish_draw_b10? DRAW_b11 : DRAW_b10;
			DRAW_b11: next_state = finish_draw_b11? WAIT : DRAW_b11;
			WAIT: next_state = WAIT;
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
		enb5 = 1'b0;
		enb6 = 1'b0;
		enb7 = 1'b0;
		enb8 = 1'b0;
		enb9 = 1'b0;
		enb10 = 1'b0;
		enb11 = 1'b0;
		b1 = 1'b0;
		b2 = 1'b0;
		b3 = 1'b0;
		b4 = 1'b0;
		b5 = 1'b0;
		b6 = 1'b0;
		b7 = 1'b0;
		b8 = 1'b0;
		b9 = 1'b0;
		b10 = 1'b0;
		b11 = 1'b0;
		reset_data = resetn;
		finish_draw = 1'b0;
		case (current_state)
		Begin:begin
			end
		DRAW_b1:begin
			b1 = 1'b1;
			enb1 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b2:begin
			b2 = 1'b1;
			enb2 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b3:begin
			b3 = 1'b1;
			enb3 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b4:begin
			b4 = 1'b1;
			enb4 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b5:begin
			b5 = 1'b1;
			enb5 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b6:begin
			b6 = 1'b1;
			enb6 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b7:begin
			b7 = 1'b1;
			enb7 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b8:begin
			b8 = 1'b1;
			enb8 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b9:begin
			b9 = 1'b1;
			enb9 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b10:begin
			b10 = 1'b1;
			enb10 = 1'b1;
			plot = 1'b1;
		end
		DRAW_b11:begin
			b11 = 1'b1;
			enb11 = 1'b1;
			plot = 1'b1;
		end
		WAIT:begin
			finish_draw = 1'b1;
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
