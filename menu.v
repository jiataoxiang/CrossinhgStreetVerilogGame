//module menu(
//		CLOCK_50,						//	On Board 50 MHz
//		// Your inputs and outputs here
//      KEY,
//      SW,
//		// The ports below are for the VGA output.  Do not change.
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,						//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B   						//	VGA Blue[9:0]
//	   );
//	input			CLOCK_50;				//	50 MHz
//	input   [9:0]   SW;
//	input   [3:0]   KEY;
//	// Declare your inputs and outputs here
//
//	// Do not change the following outputs
//	output			VGA_CLK;   				//	VGA Clock      
//	output			VGA_HS;					//	VGA H_SYNC
//	output			VGA_VS;					//	VGA V_SYNC
//	output			VGA_BLANK_N;				//	VGA BLANK
//	output			VGA_SYNC_N;				//	VGA SYNC
//	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
//	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
//	output	[9:0]	VGA_B;  
//	//	VGA Blue[9:0]
//	wire resetn;
//	
//	assign resetn = KEY[0];
//	// Create the colour, x, y and writeEn wires that are inputs to the controller.
//	wire [2:0] colour;
//	wire [7:0] x;
//	wire [7:0] y;
//	wire writeEn;
//	wire enable,ld_c;
//
//
//
//	// Create an Instance of a VGA controller - there can be only one!
//
//	// Define the number of colours as well as the initial background
//
//	// image file (.MIF) for the controller.
//
//	vga_adapter VGA(
//			.resetn(resetn),
//			.clock(CLOCK_50),
//			.colour(colour),
//			.x(x),
//			.y(y),
//			.plot(writeEn),
//			/* Signals for the DAC to drive the monitor. */
//			.VGA_R(VGA_R),
//			.VGA_G(VGA_G),
//			.VGA_B(VGA_B),
//			.VGA_HS(VGA_HS),
//			.VGA_VS(VGA_VS),
//			.VGA_BLANK(VGA_BLANK_N),
//			.VGA_SYNC(VGA_SYNC_N),
//			.VGA_CLK(VGA_CLK));
//		defparam VGA.RESOLUTION = "160x120";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
//		defparam VGA.BACKGROUND_IMAGE = "black.mif";
//	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
//	// for the VGA controller, in addition to any other functionality your design may require.
//    // Instansiate datapath
//	// datapath d0(...);
//	wire b1,b2,b3,b4,b5,b6,b7;
//	wire reset_data;
//	wire finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7;
//	datapath3 d3(
//		.b1(b1),.b2(b2),.b3(b3),.b4(b4),.b5(b5),.b6(b6),.b7(b7),
//		.clock(CLOCK_50), .reset_data(reset_data),
//		.x(x),
//		.y(y),
//		.colour_out(colour),
//		.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),.finish_draw_b3(finish_draw_b3),
//		.finish_draw_b4(finish_draw_b4),.finish_draw_b5(finish_draw_b5),.finish_draw_b6(finish_draw_b6),
//		.finish_draw_b7(finish_draw_b7));
//	//controller
//	FSM3 F3(
//		.clock(CLOCK_50), .resetn(resetn),
//		.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),
//		.finish_draw_b3(finish_draw_b3),.finish_draw_b4(finish_draw_b4),
//		.finish_draw_b5(finish_draw_b5),
//		.finish_draw_b6(finish_draw_b6),.finish_draw_b7(finish_draw_b7),
//		.b1(b1),.b2(b2),.b3(b3),.b4(b4),.b5(b5),.b6(b6),.b7(b7), 
//		.plot(writeEn),.reset_data(reset_data));
////	.enb1(), .enb2(),.enb3(),.enb4(),.enb4(),.enb6(), .enb7(),.finish_draw()
//
//	   	
//endmodule

module menu(
	input resetn, clock, EN,
	output plot, finish, 
	output [7:0]x,
	output [6:0]y,
	output [2:0]colour_out);
	
	// datapath d0(...);
	wire b1,b2,b3,b4,b5,b6,b7;
	wire reset_data;
	wire finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7;
	datapathm dm(
		.b1(b1),.b2(b2),.b3(b3),.b4(b4),.b5(b5),.b6(b6),.b7(b7),
		.clock(clock), .reset_data(reset_data),
		.x(x),
		.y(y),
		.colour_out(colour_out),
		.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),.finish_draw_b3(finish_draw_b3),
		.finish_draw_b4(finish_draw_b4),.finish_draw_b5(finish_draw_b5),.finish_draw_b6(finish_draw_b6),
		.finish_draw_b7(finish_draw_b7));
	//controller
	FSMm Fm(
		.clock(clock), .resetn(resetn),.EN(EN),
		.finish_draw_b1(finish_draw_b1),.finish_draw_b2(finish_draw_b2),
		.finish_draw_b3(finish_draw_b3),.finish_draw_b4(finish_draw_b4),
		.finish_draw_b5(finish_draw_b5),
		.finish_draw_b6(finish_draw_b6),.finish_draw_b7(finish_draw_b7),
		.b1(b1),.b2(b2),.b3(b3),.b4(b4),.b5(b5),.b6(b6),.b7(b7), 
		.plot(plot),.finish_draw(finish),.reset_data(reset_data));

endmodule


module datapathm(
		input b1,b2,b3,b4,b5,b6,b7,
		input clock, reset_data,
		output reg [7:0]x,
		output reg [6:0]y,
		output reg [2:0] colour_out,
		output finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7);
	//colour
	always @(posedge clock)
	begin
		if (!reset_data)
			colour_out <= 3'b000;
		else
			colour_out <= 3'b011;
	
	end
	reg [7:0]x1,x2,x3,x4,x5,x6,x7;
	reg [6:0]y1,y2,y3,y4,y5,y6,y7;
	// drawing box_xcounter1
	always @(posedge clock)
	begin
		if (!reset_data)begin
			x1 <= 8'd0;
			end
		else if (x1 == 8'd10)
			x1 <= 8'd0;
		else if (b1 == 1'b1)begin
			x1 <= x1 + 1'b1;
			end
		else
			x1 <= 8'd0;
	end
	
	wire eny1;
	assign eny1 = (x1 == 10)? 1:0;
	// drawing box_ycounter1
	always @(posedge clock)
	begin
		if (!reset_data)begin
			y1 <= 7'd0;
			end
		else if (y1 == 7'd20)
			y1 <= 7'd0;
		else if (eny1 == 1'b1)begin
			y1 <= y1 + 1'b1;
			end
		else if (eny1 == 1'b0)begin 
			y1 <= y1;
			end
		else
			y1 <= 7'd0;	
	end
	assign finish_draw_b1 = (y1 == 7'd20)? 1:0;
	
		// drawing box_xcounter2
	always @(posedge clock)
	begin
		if (!reset_data)begin
			x2 <= 8'd0;
			end
		else if (x2 == 8'd20)
			x2 <= 8'd0;
		else if (b2 == 1'b1)begin
			x2 <= x2 + 1'b1;
			end
		else
			x2 <= 8'd0;
	end
	
	wire eny2;
	assign eny2 = (x2 == 20)? 1:0;
	// drawing box_ycounter2
	always @(posedge clock)
	begin
		if (!reset_data)begin
			y2 <= 7'd0;
			end
		else if (y2 == 7'd30)
			y2 <= 7'd0;
		else if (eny2 == 1'b1)begin
			y2 <= y2 + 1'b1;
			end
		else if (eny2 == 1'b0)begin 
			y2 <= y2;
			end
		else
			y2 <= 7'd0;	
	end
	assign finish_draw_b2 = (y2 == 7'd30)? 1:0;
	
			// drawing box_xcounter3
	always @(posedge clock)
	begin
		if (!reset_data)begin
			x3 <= 8'd0;
			end
		else if (x3 == 8'd3)
			x3 <= 8'd0;
		else if (b3 == 1'b1)begin
			x3 <= x3 + 1'b1;
			end
		else
			x3 <= 8'd0;
	end
	
	wire eny3;
	assign eny3 = (x3 == 3)? 1:0;
	// drawing box_ycounter3
	always @(posedge clock)
	begin
		if (!reset_data)begin
			y3 <= 7'd0;
			end
		else if (y3 == 7'd10)
			y3 <= 7'd0;
		else if (eny3 == 1'b1)begin
			y3 <= y3 + 1'b1;
			end
		else if (eny3 == 1'b0)begin 
			y3 <= y3;
			end
		else
			y3 <= 7'd0;	
	end
	assign finish_draw_b3 = (y3 == 7'd10)? 1:0;
	
//		// drawing box_xcounter4
//	always @(posedge clock)
//	begin
//		if (!reset_data)begin
//			x4 <= 8'd0;
//			end
//		else if (x4 == 8'd10)
//			x4 <= 8'd0;
//		else if (b4 == 1'b1)begin
//			x4 <= x4 + 1'b1;
//			end
//		else
//			x4 <= 8'd0;
//	end
//	
//	wire eny4;
//	assign eny4 = (x4 == 10)? 1:0;
//	// drawing box_ycounter4
//	always @(posedge clock)
//	begin
//		if (!reset_data)begin
//			y4 <= 7'd0;
//			end
//		else if (y4 == 7'd5)
//			y4 <= 7'd0;
//		else if (eny4 == 1'b1)begin
//			y4 <= y4 + 1'b1;
//			end
//		else if (eny4 == 1'b0)begin 
//			y4 <= y4;
//			end
//		else
//			y4 <= 7'd0;	
//	end
	
	
		// drawing box_xcounter5
	always @(posedge clock)
	begin
		if (!reset_data)begin
			x5 <= 8'd0;
			end
		else if (x5 == 8'd60)
			x5 <= 8'd0;
		else if (b5 == 1'b1)begin
			x5 <= x5 + 1'b1;
			end
		else
			x5 <= 8'd0;
	end
	
	wire eny5;
	assign eny5 = (x5 == 8'd60)? 1:0;
	// drawing box_ycounter5
	always @(posedge clock)
	begin
		if (!reset_data)begin
			y5 <= 7'd0;
			end
		else if (y5 == 7'd35)
			y5 <= 7'd0;
		else if (eny5 == 1'b1)begin
			y5 <= y5 + 1'b1;
			end
		else if (eny5 == 1'b0)begin 
			y5 <= y5;
			end
		else
			y5 <= 7'd0;	
	end
	assign finish_draw_b5 = (y5 == 7'd35)? 1:0;
	
//		// drawing box_xcounter6
//	always @(posedge clock)
//	begin
//		if (!reset_data)begin
//			x6 <= 8'd0;
//			end
//		else if (x6 == 8'd10)
//			x6 <= 8'd0;
//		else if (b6 == 1'b1)begin
//			x6 <= x6 + 1'b1;
//			end
//		else
//			x6 <= 8'd0;
//	end
//	
//	wire eny6;
//	assign eny6 = (x6 == 10)? 1:0;
//	// drawing box_ycounter6
//	always @(posedge clock)
//	begin
//		if (!reset_data)begin
//			y6 <= 7'd0;
//			end
//		else if (y6 == 7'd5)
//			y6 <= 7'd0;
//		else if (eny6 == 1'b1)begin
//			y6 <= y6 + 1'b1;
//			end
//		else if (eny6 == 1'b0)begin 
//			y6 <= y6;
//			end
//		else
//			y6 <= 7'd0;	
//	end
	
	
	
		// drawing box_xcounter7
	always @(posedge clock)
	begin
		if (!reset_data)begin
			x7 <= 8'd0;
			end
		else if (x7 == 8'd7)
			x7 <= 8'd0;
		else if (b7 == 1'b1)begin
			x7 <= x7 + 1'b1;
			end
		else
			x7 <= 8'd0;
	end
	
	wire eny7;
	assign eny7 = (x7 == 7)? 1:0;
	// drawing box_ycounter3
	always @(posedge clock)
	begin
		if (!reset_data)begin
			y7 <= 7'd0;
			end
		else if (y7 == 7'd3)
			y7 <= 7'd0;
		else if (eny7 == 1'b1)begin
			y7 <= y7 + 1'b1;
			end
		else if (eny7 == 1'b0)begin 
			y7 <= y7;
			end
		else
			y7 <= 7'd0;	
	end
	assign finish_draw_b7 = (y7 == 7'd3)? 1:0;
	
	//tire, counter4 and 6
	reg [5:0]q;
	reg [5:0]q1;
	always @(posedge clock)
	begin
		if (!reset_data)
			q <= 6'b0000000;
		else if (q == 6'b100111)
			q <= 6'b000000;
		else if (b4 == 1'b1)
			q <= q + 1;
	end
	
	always @(posedge clock)
	begin
		if (!reset_data)
			q1 <= 6'b0000000;
		else if (q == 6'b100111)
			q1 <= 6'b000000;
		else if (b6 == 1'b1)
			q1 <= q1 + 1;
	end
	assign finish_draw_b4 = (q == 6'b100111)? 1:0;
	assign finish_draw_b6 = (q1 == 6'b100111)? 1:0;
	
	always @(*)
	begin
		if (b1)begin
			x = 8'd80 + x1;
			y = 7'd50 + y1;
			end
		else if (b2)begin
			x = 8'd90 + x2;
			y = 7'd40 + y2;
			end
		else if (b3)begin
			x = 8'd110 + x3;
			y = 7'd55 + y3;
			end
		//set original value
		else if (b4)begin
			x = 8'd87 + q[2:0];
			y = 7'd70 + q[5:3];
			end
		else if (b5)begin
			x = 8'd113 + x5;
			y = 7'd35 + y5;
			end
		else if (b6)begin
			x = 8'd120 + q1[2:0];
			y = 7'd70 + q1[5:3];
			end
		else if (b7)begin
			x = 8'd83 + x7;
			y = 7'd47 + y7;
			end
	end


endmodule



module FSMm (
	input clock, resetn,EN,finish_draw_b1,finish_draw_b2,finish_draw_b3,finish_draw_b4,finish_draw_b5,finish_draw_b6,finish_draw_b7,
	output reg enb1, enb2,enb3,enb4,enb5,enb6, enb7, b1,b2,b3,b4,b5,b6,b7, plot, finish_draw,reset_data);

	reg [4:0] current_state, next_state;
	
	localparam DRAW_b1 = 5'd0,
				DRAW_b2 = 5'd1,
				DRAW_b3 = 5'd2,
				DRAW_b4 = 5'd3,
				DRAW_b5 = 5'd4,
				DRAW_b6 = 5'd5,
				DRAW_b7 = 5'd6,
				WAIT = 5'd7,
				RESET = 5'd8;
					

	always @(*)
	begin: state_table
		case (current_state)
			RESET: next_state = EN? DRAW_b1: RESET;
			DRAW_b1: next_state = finish_draw_b1? DRAW_b2 : DRAW_b1;
			DRAW_b2: next_state = finish_draw_b2? DRAW_b3 : DRAW_b2;
			DRAW_b3: next_state = finish_draw_b3? DRAW_b4 : DRAW_b3;
			DRAW_b4: next_state = finish_draw_b4? DRAW_b5 : DRAW_b4;
			DRAW_b5: next_state = finish_draw_b5? DRAW_b6 : DRAW_b5;
			DRAW_b6: next_state = finish_draw_b6? DRAW_b7 : DRAW_b6;
			DRAW_b7: next_state = finish_draw_b7? WAIT : DRAW_b7;
			WAIT: next_state = WAIT;
			default: next_state = RESET;
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
		b1 = 1'b0;
		b2 = 1'b0;
		b3 = 1'b0;
		b4 = 1'b0;
		b5 = 1'b0;
		b6 = 1'b0;
		b7 = 1'b0;
		reset_data = resetn;
		finish_draw = 1'b0;
		case (current_state)
		RESET:begin
			reset_data = 1'b0;
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
		WAIT:begin
			finish_draw = 1'b1;
		end
		endcase
	end
	
	
	always@(posedge clock)
    begin: state_FFs
        if(!resetn)
            current_state <= RESET;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
