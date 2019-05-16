module counter(CLOCK_50, resetn, HEX0, HEX1, HEX2, EN);
input CLOCK_50;
input resetn, EN;
output [6:0]HEX0, HEX1, HEX2;

wire [11:0]toHex;
theCounter t0 (.clock(CLOCK_50), .out(toHex), .resetn(resetn), .EN(EN));
seven_seg_decoder s0(.LED(HEX0[6:0]), .c(toHex[3:0]));
seven_seg_decoder s1(.LED(HEX1[6:0]), .c(toHex[7:4]));
seven_seg_decoder s2(.LED(HEX2[6:0]), .c(toHex[11:8]));

endmodule

module seven_seg_decoder (LED, c);
	input [3:0] c;
	output [6:0] LED;

	assign LED[0] = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & c[2] & ~c[1] & ~c[0] | c[3] & ~c[2] & c[1] & c[0] | c[3] & c[2] & ~c[1] & c[0];
	
	assign LED[1] = ~c[3] & c[2] & ~c[1] & c[0] | c[3] & c[2] & ~c[0] | c[3] & c[1] & c[0] | c[2] & c[1] & ~c[0];
	
	assign LED[2] = c[3] & c[2] & ~c[0] | c[3] & c[2] & c[1] | ~c[3] & ~c[2] & c[1] & ~c[0];
	
	assign LED[3] = ~c[3] & c[2] & ~c[1] & ~c[0] | ~c[3] & ~c[2] & ~c[1] & c[0] | c[2] & c[1] & c[0] | c[3] & ~c[2] & c[1] & ~c[0];
	
	assign LED[4] = ~c[3] & c[2] & ~c[1] | ~c[3] & c[0] | ~c[2] & ~c[1] & c[0];
	
	assign LED[5] = ~c[3] & ~c[2] & c[0] | ~c[3] & c[1] & c[0] | ~c[3] & ~c[2] & c[1] | c[3] & c[2] & ~c[1] & c[0];
	
	assign LED[6] = ~c[3] & ~c[2] & ~c[1] | c[3] & c[2] & ~c[1] & ~c[0] | ~c[3] & c[2] & c[1] & c[0];
	
endmodule


module theCounter(clock, out, resetn, EN);
input clock, resetn, EN;
output [11:0]out;

wire [27:0]rateDriveOut;
RateDivider r0(.d(5*10**7-1), .clock(clock),.resetn(resetn),.enable(EN),.q(rateDriveOut), .parload(~enable));
assign enable = (rateDriveOut == 0) ? 1 : 0;
DisplayCounter d0(.clock(clock),.resetn(resetn), .enable(enable), .q(out[3:0]), .q2(out[7:4]), .q3(out[11:8]));
endmodule





module RateDivider(d,clock,resetn,enable, q, parload);
input clock, parload;
input resetn;
input enable;
input [27:0]d;
output reg [27:0]q;

	always @(posedge clock) // Tr i g g e r ed e v e ry t ime c l o c k r i s e s
	begin
		if (resetn == 1'b0 ) // When r e s e t n i s 0
			q <= d; // Set q to 0
		else if (parload == 1'b0) // Check i f p a r a l l e l load
			q <= d; // Load d
		else if ( enable == 1'b1 ) // Increment q only when enab l e i s 1
			q <= q - 1'b1; // Increment q
	end
endmodule




module DisplayCounter(clock,resetn, enable, q, q2, q3);
input clock;
input resetn;
input enable;
output reg [3:0]q, q2, q3;

	always @(posedge clock) // Tr i g g e r ed e v e ry t ime c l o c k r i s e s
	begin
		if (resetn == 1'b0 ) // When r e s e t n i s 0
		begin
			q <= 0; // Set q to 0\
			q2<= 0;
			q3 <= 0;
		end
		else if ( q == 4'b1010 )
		begin
			q <= 4'b0; // resetq
			q2 <= q2 + 1'b1; // Increment q2
		end
		else if ( q2 == 4'b1010 )
		begin
			q2 <= 4'b0; // resetq2
			q3 <= q3 + 1'b1; // Increment q3
		end
		else if ( enable == 1'b1 ) // Increment q only when enab l e i s 1
			q <= q + 1'b1; // Increment q
	end
endmodule
