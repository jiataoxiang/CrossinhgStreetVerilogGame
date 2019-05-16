
module project(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
      KEY,
      SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1,
		HEX2
	   );
	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	// Declare your inputs and outputs here

	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock      
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;  
	//	VGA Blue[9:0]
	output [6:0]HEX0, HEX1, HEX2;
	
	wire resetn;
	
	assign resetn = KEY[0];
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	reg [2:0] colour;
	reg [7:0] x;
	reg [7:0] y;
	reg writeEn;
	wire enable,ld_c;



	// Create an Instance of a VGA controller - there can be only one!

	// Define the number of colours as well as the initial background

	// image file (.MIF) for the controller.

	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    wire [2:0] colourBg, colour1, colour2, colour3, colour4,colour5,colour6,colour7,colour8,colour9,colour10,colour11,colour12, colourp, coloure,colourm, colourClear,colourentrance,colourcrush;
	 wire [7:0]x0, x1,x2, x3, x4,x5,x6,x7,x8,x9,x10,x11,x12, xp, xm, xc,xe,xentrance,xcrush;
	 wire [6:0]y0, y1,y2, y3, y4,y5,y6,y7,y8,y9,y10,y11,y12, yp, ym, yc,ye,yentrance,ycrush;
	 wire finish_F0, finish_F1, finish_F2, finish_F3, finish_F4,finish_F5,finish_F6,finish_F7,finish_F8,finish_F9,finish_F10,finish_F11,finish_F12, finish_p, finish_e,finish_m, finish_c,finish_entrance,finish_crush;
	 wire writeEnBc, writeEn1, writeEn2, writeEn3, writeEn4,writeEn5,writeEn6,writeEn7,writeEn8,writeEn9,writeEn10,writeEn11,writeEn12, writeEnp, writeEnm, writeEnc,writeEne,writeEnentrance,writeEncrush;
	 wire ENbc, EN1,EN2, EN3, EN4,EN5,EN6,EN7,EN8,EN9,EN10,EN11,EN12, ENp, ENm, ENc,ENe,ENentrance,ENcrush;
	 wire resetCar;
	 
	 wire [4:0] mux;
    // Instansiate datapath
	 
	 reg ENcount;
	 //counter
	 counter count0(
	 .CLOCK_50(CLOCK_50), 
	 .resetn(resetCar), 
	 .HEX0(HEX0), 
	 .HEX1(HEX1), 
	 .HEX2(HEX2),
	 .EN(ENcount));
	 
	 
	 
	 always@(*)
	 begin
		if(~resetCar)ENcount <= 0;
		else if(x_ori_h == 8'd26 && y_ori_h == 8'd21) ENcount <= 1;
		else if((endgame)||(crushed))ENcount <= 0;
	 end
	 
	 
	 //entrance
	entrance entrance0(
		.resetn(resetCar),.clock(CLOCK_50), .EN(ENentrance),
		.plot(writeEnentrance),.finish(finish_entrance),
		.x(xentrance),
		.y(yentrance),
		.colour_out(colourentrance));
	 
	 //background
	 background b0(
		.resetn(resetCar),
		.clock(CLOCK_50),
		.EN(ENbc),
		.plot(writeEnBc),
		.finish(finish_F0),
		.x(x0),
		.y(y0),
		.colour_out(colourBg));
		
		
	//menu
	menu m0(
	.resetn(resetCar), 
	.clock(CLOCK_50), 
	.EN(ENm),
	.plot(writeEnm), 
	.finish(finish_m), 
	.x(xm),
	.y(ym),
	.colour_out(colourm));
	//crushed
	crush crush0(
	.resetn(resetCar), 
	.clock(CLOCK_50), 
	.EN(ENcrush),
	.plot(writeEncrush), 
	.finish(finish_crush), 
	.x(xcrush),
	.y(ycrush),
	.colour_out(colourcrush));
	
	//endstate
	endgame e0(
	.resetn(resetCar), 
	.clock(CLOCK_50), 
	.EN(ENe),
	.plot(writeEne), 
	.finish(finish_e), 
	.x(xe),
	.y(ye),
	.colour_out(coloure));
		
		
	//clear all
	clearAll clear0 (
	.resetn(resetCar), 
	.clock(CLOCK_50), 
	.enable(ENc), 
	.finish_draw(finish_c), 
	.plot(writeEnc), 
	.output_x(xc), 
	.output_y(yc), 
	.colour_out(colourClear));
	 
	 
	 wire [7:0]x_ori_c1,x_ori_c2,x_ori_c3,x_ori_c4,x_ori_c5,x_ori_c6,x_ori_c7,x_ori_c8,x_ori_c9, x_ori_c10,x_ori_c11,x_ori_c12;
	 wire [6:0]y_ori_c9, y_ori_c10;
	 wire right, down,right1,down1;
	// car1
      	car1 c1(
			.colour(3'b001),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN1),
			.plot(writeEn1),
			.finish_F1(finish_F1),
			.x(x1),
			.y(y1),
		   .colour_out(colour1),
			.x_ori(x_ori_c1));

    // car2
	   	car2 c2(
			.colour(3'b010),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN2),
			.plot(writeEn2),
			.finish_F2(finish_F2),
			.x(x2),
			.y(y2),
		   .colour_out(colour2),
			.x_ori(x_ori_c2));
			
	// car3
	   	car3 c3(
			.colour(3'b011),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN3),
			.plot(writeEn3),
			.finish_F3(finish_F3),
			.x(x3),
			.y(y3),
		   .colour_out(colour3),
			.x_ori(x_ori_c3));
			
		//car4
			car4 c4(
			.colour(3'b100),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN4),
			.plot(writeEn4),
			.finish_F4(finish_F4),
			.x(x4),
			.y(y4),
		   .colour_out(colour4),
			.x_ori(x_ori_c4));
		// car5
      	car5 c5(
			.colour(3'b101),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN5),
			.plot(writeEn5),
			.finish_F1(finish_F5),
			.x(x5),
			.y(y5),
		   .colour_out(colour5),
			.x_ori(x_ori_c5));
		// car6
	   	car6 c6(
			.colour(3'b110),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN6),
			.plot(writeEn6),
			.finish_F2(finish_F6),
			.x(x6),
			.y(y6),
		   .colour_out(colour6),
			.x_ori(x_ori_c6));
		// car7
	   	car7 c7(
			.colour(3'b111),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN7),
			.plot(writeEn7),
			.finish_F3(finish_F7),
			.x(x7),
			.y(y7),
		   .colour_out(colour7),
			.x_ori(x_ori_c7));
		// car8
	   	car8 c8(
			.colour(3'b001),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN8),
			.plot(writeEn8),
			.finish_F3(finish_F8),
			.x(x8),
			.y(y8),
		   .colour_out(colour8),
			.x_ori(x_ori_c8));
		// moto car9
		motocar9 c9(
		.colour(3'b110),
		.resetn(resetCar),
		.clk(CLOCK_50),
		.EN(EN9),
		.right(right), 
		.down(down),
		.plot(writeEn9),
		.finish_F1(finish_F9),
		.x(x9),
		.y(y9),
		.colour_out(colour9),
		.x_ori(x_ori_c9),
		.y_ori(y_ori_c9)
		);
		
		// moto car10
		motocar10 c10(
		.colour(3'b110),
		.resetn(resetCar),
		.clk(CLOCK_50),
		.EN(EN10),
		.right(right1), 
		.down(down1),
		.plot(writeEn10),
		.finish_F1(finish_F10),
		.x(x10),
		.y(y10),
		.colour_out(colour10),
		.x_ori(x_ori_c10),
		.y_ori(y_ori_c10)
		);
		// car11
      	car11 c11(
			.colour(3'b001),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN11),
			.plot(writeEn11),
			.finish_F1(finish_F11),
			.x(x11),
			.y(y11),
		   .colour_out(colour11),
			.x_ori(x_ori_c11));
		// car12
	   	car12 c12(
			.colour(3'b011),
			.resetn(resetCar),
			.clk(CLOCK_50),
			.EN(EN12),
			.plot(writeEn12),
			.finish_F3(finish_F12),
			.x(x12),
			.y(y12),
		   .colour_out(colour12),
			.x_ori(x_ori_c12));
			
		wire [7:0] x_ori_h;
		wire [6:0] y_ori_h;
		//human
		human h1(
		.colour(SW[6:4]),
		.resetn(resetCar),
		.clk(CLOCK_50),
		.EN(ENp), 
		.left(SW[3]), 
		.right(SW[2]), 
		.up(SW[1]), 
		.down(SW[0]),
		.plot(writeEnp),
		.finish_P(finish_p),
		.x(xp),
		.y(yp),
		.x_ori(x_ori_h),
		.y_ori(y_ori_h),
		.colour_out(colourp));
		
		
		wire crushed, enCompare,level_up,endgame;
		//assign LEDR[0] = (y_ori_h >= 7'd27 && y_ori_h <= 7'd31);
		
		//compare if crushed
		comparator(
		.resetn(resetCar), 
		.clock(CLOCK_50), 
		.human_x(x_ori_h), 
		.car1_x(x_ori_c1),
		.car2_x(x_ori_c2),
		.car3_x(x_ori_c3),
		.car4_x(x_ori_c4),
		.car5_x(x_ori_c5),
		.car6_x(x_ori_c6),
		.car7_x(x_ori_c7),
		.car8_x(x_ori_c8),
		.car9_x(x_ori_c9),
		.car9_y(y_ori_c9),
		.right(right),
		.down(down),
		.car10_x(x_ori_c10),
		.car10_y(y_ori_c10),
		.car11_x(x_ori_c11),
		.car12_x(x_ori_c12),
		.right1(right1),
		.down1(down1),
		.human_y(y_ori_h), 
		.crushed(crushed),
		.enable(enCompare),
		.level_up(level_up),
		.endgame(endgame));
		
		
		//bigFSM
		BIGFSM F1(
		.finish_bc(finish_F0),
		.finish_F1(finish_F1), 
		.finish_F2(finish_F2),
		.finish_F3(finish_F3),
		.finish_F4(finish_F4),
		.finish_F5(finish_F5),
		.finish_F6(finish_F6),
		.finish_F7(finish_F7),
		.finish_F8(finish_F8),
		.finish_F9(finish_F9),
		.finish_F10(finish_F10),
		.finish_F11(finish_F11),
		.finish_F12(finish_F12),
		.finish_p(finish_p),
		.finish_m(finish_m),
		.finish_c(finish_c),
		.finish_e(finish_e),
		.finish_entrance(finish_entrance),
		.finish_crush(finish_crush),
		.clk(CLOCK_50),
		.resetn(resetn),
		.start(KEY[1]),
		.crushed(crushed),
		.level_up(level_up),
		.ENbc(ENbc),
		.EN1(EN1), 
		.EN2(EN2),
		.EN3(EN3),
		.EN4(EN4),
		.EN5(EN5),
		.EN6(EN6),
		.EN7(EN7),
		.EN8(EN8),
		.EN9(EN9),
		.EN10(EN10),
		.EN11(EN11),
		.EN12(EN12),
		.ENp(ENp),
		.ENm(ENm),
		.ENc(ENc),
		.ENe(ENe),
		.ENentrance(ENentrance),
		.ENcrush(ENcrush),
		.ENcompare(enCompare),
		.resetCar(resetCar),
		.mux(mux),
		.endgame(endgame));
			
			always @(*)
			begin
			   if (mux == 5'b00000)begin
					writeEn <= writeEnBc;
					x <= x0;
					y <= y0;
					colour <= colourBg;
					end
				else if (mux == 5'b00010)begin
					writeEn <= writeEn2;
					x <= x2;
					y <= y2;
					colour <= colour2;
					end
				else if (mux == 5'b00001)begin
					writeEn <= writeEn1;
					x <= x1;
					y <= y1;
					colour <= colour1;
					end
				else if (mux == 5'b00011)begin
					writeEn <= writeEn3;
					x <= x3;
					y <= y3;
					colour <= colour3;
					end
				else if (mux == 5'b00100)begin
					writeEn <= writeEn4;
					x <= x4;
					y <= y4;
					colour <= colour4;
					end
				else if (mux == 5'b00101)begin
					writeEn <= writeEnp;
					x <= xp;
					y <= yp;
					colour <= colourp;
					end
				else if (mux == 5'b00110)begin
					writeEn <= writeEnm;
					x <= xm;
					y <= ym;
					colour <= colourm;
					end
				else if (mux == 5'b00111)begin
					writeEn <= writeEnc;
					x <= xc;
					y <= yc;
					colour <= colourClear;
					end
				else if (mux == 5'b01000)begin
					writeEn <= writeEn5;
					x <= x5;
					y <= y5;
					colour <= colour5;
					end
				else if (mux == 5'b01001)begin
					writeEn <= writeEn6;
					x <= x6;
					y <= y6;
					colour <= colour6;
					end
				else if (mux == 5'b01010)begin
					writeEn <= writeEn7;
					x <= x7;
					y <= y7;
					colour <= colour7;
					end
				else if (mux == 5'b01011)begin
					writeEn <= writeEn8;
					x <= x8;
					y <= y8;
					colour <= colour8;
					end
				else if (mux == 5'b01100)begin
					writeEn <= writeEn9;
					x <= x9;
					y <= y9;
					colour <= colour9;
					end
				else if (mux == 5'b01101)begin
					writeEn <= writeEn10;
					x <= x10;
					y <= y10;
					colour <= colour10;
					end
				else if (mux == 5'b01110)begin
					writeEn <= writeEne;
					x <= xe;
					y <= ye;
					colour <= coloure;
					end
				else if (mux == 5'b01111)begin
					writeEn <= writeEnentrance;
					x <= xentrance;
					y <= yentrance;
					colour <= colourentrance;
					end
				else if (mux == 5'b10000)begin
					writeEn <= writeEn11;
					x <= x11;
					y <= y11;
					colour <= colour11;
					end
				else if (mux == 5'b10001)begin
					writeEn <= writeEn12;
					x <= x12;
					y <= y12;
					colour <= colour12;
					end
				else if (mux == 5'b10010)begin
					writeEn <= writeEncrush;
					x <= xcrush;
					y <= ycrush;
					colour <= colourcrush;
					end
				else begin
				   writeEn <= 0;
					x <= 0;
					y <= 0;
					colour <= 3'b000;
					end
				
					
			end

endmodule

module BIGFSM (
		input finish_bc, finish_F1, finish_F2, finish_F3, finish_F4,finish_F5,finish_F6,finish_F7,finish_F8,finish_F9,finish_F10,finish_F11,finish_F12, finish_p, finish_m,finish_c,finish_e,finish_entrance, finish_crush, 
		clk,resetn, start,crushed,level_up,endgame,
		output reg ENbc, EN1, EN2, EN3, EN4,EN5,EN6,EN7,EN8,EN9,EN10,EN11,EN12, ENp,ENm, ENc,ENe,ENentrance,ENcrush,ENcompare, resetCar,	
		output reg [4:0] mux);
	
		
		reg [4:0]current_state,next_state;

	localparam  Initiate   = 32'd0,
					Menu       = 32'd1,
					BackGround = 32'd2,
	            CAR1       = 32'd3,
			      CAR2       = 32'd4,
					CAR21       = 32'd19,
					CAR3       = 32'd5,
					CAR4       = 32'd6,
					CAR5       = 32'd10,
					CAR6       = 32'd11,
					CAR61       = 32'd20,
					CAR7       = 32'd12,
					CAR8       = 32'd13,
					CAR9       = 32'd14,
					CAR91       = 32'd15,
					CAR10       = 32'd16,
					CAR11       = 32'd21,
					CAR12       = 32'd22,
					END        = 32'd17,
					Human1     = 32'd7,
					Clear      = 32'd8,
					Crushed    = 32'd9,
					ENTRANCE   = 32'd18,
					Crush    = 32'd23;
	
//	reg [1:0]counter1, counter2;
//	always @(posedge clk)
//	begin
//		if (!resetn)begin
//			counter1 <= 2'b00;
//			counter2 <= 2'b00;
//			end
//		else if (counter1 == 2'b11)
//			counter1 <= 2'b00;
//		else if (counter2 == 2'b11)
//			counter2 <= 2'b00;
//		if (finish_F2 == 1)
//			counter1 <= counter1 + 1;
//		if (finish_F6 == 1)
//			counter2 <= counter2 + 1;
//	end

	always @(*)
	begin: state_table
		case (current_state)
		   Initiate:       next_state = Menu;
			Menu:     		next_state = finish_m&~start ?  Clear : Menu;
			Clear:     		next_state = finish_c ?  ENTRANCE : Clear;
			ENTRANCE:      next_state = finish_entrance? BackGround : ENTRANCE;
			BackGround:     next_state = finish_bc ?  CAR1 : BackGround;
			CAR1:           next_state = finish_F1 ?  CAR2 : CAR1;
			CAR2:           next_state = finish_F2 ?  CAR21 : CAR2;
			CAR21:           next_state = finish_F2 ?  CAR3 : CAR21;
			CAR3:           next_state = finish_F3 ?  CAR4 : CAR3;
			CAR4:           next_state = finish_F4 ?  CAR5 : CAR4;
			CAR5:           next_state = finish_F5 ?  CAR6 : CAR5;
			CAR6:           next_state = finish_F6 ?  CAR61 : CAR6;
			CAR61:           next_state = finish_F6 ?  CAR7 : CAR61;
			CAR7:           next_state = finish_F7 ?  CAR8 : CAR7;
			CAR8:           next_state = finish_F8 ? CAR9 : CAR8;
			CAR9:          begin
								if (level_up)
									next_state = finish_F9 ? CAR91 : CAR9;
								else
									next_state = CAR91;
								end
			CAR91:         begin
								if (level_up)
									next_state = finish_F9 ? CAR10 : CAR91;
								else
									next_state = CAR10;
								end
			CAR10:         begin
								if (level_up)
									next_state = finish_F10 ? CAR11 : CAR10;
								else
									next_state = CAR11;
								end
			CAR11:          begin
								if (level_up)
									next_state = finish_F11 ? CAR12 : CAR11;
								else
									next_state = CAR12;
								end
			CAR12:          begin
								if (level_up)
									next_state = finish_F12 ? Human1 : CAR12;
								else
									next_state = Human1;
								end
			Human1:         next_state = finish_p?   Crush : Human1;
			Crush:            begin
									if (crushed)
										next_state = Crush;
									else
										next_state = END;
								end
			END:            begin
									if (endgame)
										next_state = END;
									else
										next_state = BackGround;
								end
			default: next_state = BackGround;
		endcase
	end
	
	always @(*)
	begin: signals
	  ENbc = 1'b0;
		EN1 = 1'b0;
		EN2 = 1'b0;
		EN3 = 1'b0;
		EN4 = 1'b0;
		EN5 = 1'b0;
		EN6 = 1'b0;
		EN7 = 1'b0;
		EN8 = 1'b0;
		EN9 = 1'b0;
		EN10 = 1'b0;
		EN11 = 1'b0;
		EN12 = 1'b0;
		ENp = 1'b0;
		ENm = 1'b0;
		ENc = 1'b0;
		ENe = 1'b0;
		ENentrance = 1'b0;
		mux = 5'b00000;
		ENcompare = 1'b0;
		ENcrush = 1'b0;
		resetCar = resetn;
		
		case (current_state)
		Initiate: begin
			resetCar = 1'b0;
			end
		ENTRANCE: begin
			ENentrance = 1'b1;
			mux = 5'b01111;
			end
		BackGround: begin
			ENbc = 1'b1;
			mux = 5'b00000;
			end
		CAR1: begin
			EN1 = 1'b1;
			mux = 5'b00001;
			end
		CAR2: begin
			EN2 = 1'b1;
			mux = 5'b00010;
			end
		CAR21: begin
			EN2 = 1'b1;
			mux = 5'b00010;
			end
		CAR3: begin
			EN3 = 1'b1;
			mux = 5'b00011;
			end
		CAR4: begin
			EN4 = 1'b1;
			mux = 5'b00100;
			end
		CAR5: begin
			EN5 = 1'b1;
			mux = 5'b01000;
			end
		CAR6: begin
			EN6 = 1'b1;
			mux = 5'b01001;
			end
		CAR61: begin
			EN6 = 1'b1;
			mux = 5'b01001;
			end
		CAR7: begin
			EN7 = 1'b1;
			mux = 5'b01010;
			end
		CAR8: begin
			EN8 = 1'b1;
			mux = 5'b01011;
			end
		CAR9:
		begin
		if(level_up)
			begin
			EN9 = 1'b1;
			mux = 5'b01100;
			end
		end
		CAR91: 
		begin
		if(level_up)
			begin
			EN9 = 1'b1;
			mux = 5'b01100;
			end
		end
		CAR10: 
		begin
		if(level_up)
			begin
			EN10 = 1'b1;
			mux = 5'b01101;
			end
		end
		CAR11: 
		begin
		if(level_up)
			begin
			EN11 = 1'b1;
			mux = 5'b10000;
			end
		end
		CAR12: 
		begin
		if(level_up)
			begin
			EN12 = 1'b1;
			mux = 5'b10001;
			end
		end
		Human1: 
		begin
			ENp = 1'b1;
			mux = 5'b00101;
		end
		Menu: begin
			ENm = 1'b1;
			mux = 5'b00110;
			end
		Clear: begin
			ENc = 1'b1;
			mux = 5'b00111;
			end
		END: begin
			if(endgame)begin
				ENe = 1'b1;
				mux = 5'b01110;
				end
			end
		Crush: begin
			if(crushed)begin
				ENcrush = 1'b1;
				mux = 5'b10010;
				end
			end
		endcase
	end
	
	
always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= Clear;
        else
            current_state <= next_state;
    end // state_FFS
endmodule


module clearAll(resetn, clock, enable, finish_draw, plot, output_x, output_y, colour_out);
	input resetn, clock, enable;//19200 2^15
	output reg finish_draw, plot;
	output reg [7:0] output_x;
	output reg [6:0] output_y;
	output reg [2:0] colour_out;
	
	reg [7:0] input_x;
	reg [6:0] input_y; 
	
	always @(posedge clock)
	begin: load_register
		if (!resetn) begin
			colour_out <= 3'b000;
			input_x <= 0;
			input_y <= 0;
			end
		else 
			begin
			colour_out <= 3'b000;
			end
	end
	
	
	reg [7:0] q;//x
	reg [6:0] p;//y
	//draw
	always @(posedge clock)
	begin: counter_draw
		if (!resetn) begin
			finish_draw <= 1'b0;
			q <= 0;
			p <= 0;
			plot <= 1'b0;
			end
		else if (enable)
			begin
				if(p == 120 && q == 160)begin
					finish_draw <= 1'b1;
					q <= 0;
					p <= 0;
				end
				else if (q == 160) begin
					q <= 0;
					p <= p + 1'b1;
					plot <= 1'b1;
					end
				else begin
					finish_draw <= 1'b0;
					q <= q + 1'b1;
					plot <= 1'b1;
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
				output_x = input_x + q;
				output_y = input_y + p;
			end
	end
	
	
endmodule
