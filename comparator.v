module comparator(resetn, clock, 
						human_x, car1_x,car2_x,car3_x, car4_x, car5_x,car6_x,car7_x,car8_x,car9_x,car9_y,car10_x,car10_y,car11_x,car12_x,
						right,down,right1,down1,
						human_y, crushed, enable,level_up,endgame);
	input resetn, clock, enable;
	input [7:0]human_x, car1_x,car2_x,car3_x,car4_x,car5_x,car6_x,car7_x,car8_x,car9_x,car10_x,car11_x,car12_x;
	input [6:0]car9_y,car10_y;
	input [6:0]human_y;
	output reg crushed, endgame;
	output reg level_up = 1'b0;
	output reg right, down,right1,down1;
	// moto car9 direction
	always@(posedge clock)
	begin
		if (car9_x <= 8'd26)
			right <= 1'b1;
		if (car9_x >= 8'd130)
			right <= 1'b0;
		if ((car9_y >= 7'd27)&& (car9_y <= 7'd31))begin	//at the line has car1
			if (car9_x == car1_x + 7'd8)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car1_x)begin
				right <= 1'b0;
				end
			if (car9_x == car4_x + 7'd8)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car4_x)begin
				right <= 1'b0;
				end
			if (car9_x == car5_x + 7'd8)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car5_x)begin
				right <= 1'b0;
				end
		end
		if ((car9_y >= 7'd45)&&(car9_y <= 7'd49))begin
			if ((car9_x == car11_x + 7'd8))begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car11_x)begin
				right <= 1'b0;
				end
		end
		if((car9_y >= 7'd60) && (car9_y <= 7'd64))begin//at the line has car2
			if (car9_x == car2_x + 7'd16)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car2_x)begin
				right <= 1'b0;
				end
			if (car9_x == car6_x + 7'd16)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car6_x)begin
				right <= 1'b0;
				end
		end
		if ((car9_y >= 7'd75)&&(car9_y <= 7'd79))begin
			if ((car9_x == car12_x + 7'd8))begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car12_x)begin
				right <= 1'b0;
				end
			end
		if((car9_y >= 7'd90) && (car9_y <= 7'd94))begin//at the line has car3
			if (car9_x == car3_x + 7'd8)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car3_x)begin
				right <= 1'b0;
				end
			if (car9_x == car7_x + 7'd8)begin
				right <= 1'b1;
				end
			if (car9_x + 2'd3 == car7_x)begin
				right <= 1'b0;
				end
			if (car9_x == car8_x + 7'd8)begin
				right <= 1'b1;
				end
			if (car9_x +2'd3 == car8_x)begin
				right <= 1'b0;
				end
		end
		if (car9_y == 7'd24)
			down <= 1'b1;
		if (car9_y == 7'd26)begin
			if (((car9_x >= car1_x) && (car9_x <= car1_x + 8))||((car9_x >= car4_x)&&(car9_x <= car4_x+8))||((car9_x >= car5_x)&&(car9_x <= car5_x+8)))
				down <= 1'b0;
		end
		if (car9_y == 7'd32)begin
			if (((car9_x >= car1_x) && (car9_x <= car1_x + 8))||((car9_x >= car4_x)&&(car9_x <= car4_x+8))||((car9_x >= car5_x)&&(car9_x <= car5_x+8)))
				down <= 1'b1;
		end
		if (car9_y == 7'd45)begin
			if ((car9_x >= car11_x)&&(car9_x <= car11_x + 8))
				down <= 1'b0;
		end
		if (car9_y == 7'd49)begin
			if ((car9_x >= car11_x)&&(car9_x <= car11_x + 8))
				down <= 1'b1;
		end
		
		if (car9_y == 7'd59)begin
			if (((car9_x >= car2_x)&&(car9_x <= car2_x+16))||((car9_x >= car6_x)&&(car9_x <= car6_x + 16)))
				down <= 1'b0;
		end
		if (car9_y == 7'd65)begin
			if (((car9_x >= car2_x)&&(car9_x <= car2_x+16))||((car9_x >= car6_x)&&(car9_x <= car6_x + 16)))
				down <= 1'b1;
		end
		if (car9_y == 7'd75)begin
			if ((car9_x >= car12_x)&&(car9_x <= car12_x + 8))
				down <= 1'b0;
		end
		if (car9_y == 7'd79)begin
			if ((car9_x >= car12_x)&&(car9_x <= car12_x + 8))
				down <= 1'b1;
		end
		if (car9_y == 7'd89)begin
			if (((car9_x >= car3_x) && (car9_x <= car3_x + 8))||((car9_x >= car7_x)&&(car9_x <= car7_x+8))||((car9_x >= car8_x)&&(car9_x <= car8_x+8)))
				down <= 1'b0;
		end
		if (car9_y == 7'd95)begin
			if (((car9_x >= car3_x) && (car9_x <= car3_x + 8))||((car9_x >= car7_x)&&(car9_x <= car7_x+8))||((car9_x >= car8_x)&&(car9_x <= car8_x+8)))
				down <= 1'b1;
		end
		if (car9_y == 7'd103)begin
			down <= 1'b0;
		end
	end
	
	
	// moto car10 direction
	always@(posedge clock)
	begin
		if (car10_x <= 8'd26)
			right1 <= 1'b1;
		if (car10_x >= 8'd130)
			right1 <= 1'b0;
		if ((car10_y >= 7'd27)&& (car10_y <= 7'd31))begin	//at the line has car1
			if (car10_x == car1_x + 7'd8)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car1_x)begin
				right1 <= 1'b0;
				end
			if (car10_x == car4_x + 7'd8)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car4_x)begin
				right1 <= 1'b0;
				end
			if (car10_x == car5_x + 7'd8)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car5_x)begin
				right1 <= 1'b0;
				end
		end
		if ((car10_y >= 7'd45)&&(car10_y <= 7'd49))begin
			if ((car10_x == car11_x + 7'd8))begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car11_x)begin
				right1 <= 1'b0;
				end
		end
		
		if((car10_y >= 7'd60) && (car10_y <= 7'd64))begin//at the line has car2
			if (car10_x == car2_x + 7'd16)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car2_x)begin
				right1 <= 1'b0;
				end
			if (car10_x == car6_x + 7'd16)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car6_x)begin
				right1 <= 1'b0;
				end
		end
		if ((car10_y >= 7'd75)&&(car10_y <= 7'd79))begin
			if ((car10_x == car12_x + 7'd8))begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car12_x)begin
				right1 <= 1'b0;
				end
		end
		if((car10_y >= 7'd90) && (car10_y <= 7'd94))begin//at the line has car3
			if (car10_x == car3_x + 7'd8)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car3_x)begin
				right1 <= 1'b0;
				end
			if (car10_x == car7_x + 7'd8)begin
				right1 <= 1'b1;
				end
			if (car10_x + 2'd3 == car7_x)begin
				right1 <= 1'b0;
				end
			if (car10_x == car8_x + 7'd8)begin
				right1 <= 1'b1;
				end
			if (car10_x +2'd3 == car8_x)begin
				right1 <= 1'b0;
				end
		end
		if (car10_y == 7'd24)
			down1 <= 1'b1;
		if (car10_y == 7'd26)begin
			if (((car10_x >= car1_x) && (car10_x <= car1_x + 8))||((car10_x >= car4_x)&&(car10_x <= car4_x+8))||((car10_x >= car5_x)&&(car10_x <= car5_x+8)))
				down1 <= 1'b0;
		end
		if (car10_y == 7'd32)begin
			if (((car10_x >= car1_x) && (car10_x <= car1_x + 8))||((car10_x >= car4_x)&&(car10_x <= car4_x+8))||((car10_x >= car5_x)&&(car10_x <= car5_x+8)))
				down1 <= 1'b1;
		end
		if (car10_y == 7'd45)begin
			if ((car10_x >= car11_x)&&(car10_x <= car11_x + 8))
				down1 <= 1'b0;
		end
		if (car10_y == 7'd49)begin
			if ((car10_x >= car11_x)&&(car10_x <= car11_x + 8))
				down1 <= 1'b1;
		end
		
		if (car10_y == 7'd59)begin
			if (((car10_x >= car2_x)&&(car10_x <= car2_x+16))||((car10_x >= car6_x)&&(car10_x <= car6_x + 16)))
				down1 <= 1'b0;
		end
		if (car10_y == 7'd65)begin
			if (((car10_x >= car2_x)&&(car10_x <= car2_x+16))||((car10_x >= car6_x)&&(car10_x <= car6_x + 16)))
				down1 <= 1'b1;
		end
		if (car10_y == 7'd75)begin
			if ((car10_x >= car12_x)&&(car10_x <= car12_x + 8))
				down1 <= 1'b0;
		end
		if (car10_y == 7'd79)begin
			if ((car10_x >= car12_x)&&(car10_x <= car12_x + 8))
				down1 <= 1'b1;
		end
		if (car10_y == 7'd89)begin
			if (((car10_x >= car3_x) && (car10_x <= car3_x + 8))||((car10_x >= car7_x)&&(car10_x <= car7_x+8))||((car10_x >= car8_x)&&(car10_x <= car8_x+8)))
				down1 <= 1'b0;
		end
		if (car10_y == 7'd95)begin
			if (((car10_x >= car3_x) && (car10_x <= car3_x + 8))||((car10_x >= car7_x)&&(car10_x <= car7_x+8))||((car10_x >= car8_x)&&(car10_x <= car8_x+8)))
				down1 <= 1'b1;
		end
		if (car10_y == 7'd103)begin
			down1 <= 1'b0;
		end
	end
	
	always@(posedge clock)
	begin
		if(!resetn)
			level_up<= 1'b0;
		else if((human_x == 8'd133) && (human_y == 7'd102))
			level_up <= 1'b1;
	end
		
	
	
	always@(posedge clock)
	begin
	if(!resetn)begin 
		crushed <= 1'b0;
		endgame <= 1'b0;
		end
	else 
		begin
		if((human_y >= 7'd27) && (human_y <= 7'd31))//at the line has car1
			begin
			if((human_x <= car1_x + 7'd8) && (human_x >= car1_x))
				crushed <= 1'b1;
			else if ((human_x <= car5_x + 7'd8) && (human_x >= car5_x))
				crushed <= 1'b1;
			else if ((human_x <= car4_x + 7'd8) && (human_x >= car4_x))
				crushed <= 1'b1;
			end
		if (level_up)begin
			if ((human_y >= 7'd45)&&(human_y <= 7'd49))begin
				if ((human_x <= car11_x + 7'd8)&&(human_x >= car11_x))
					crushed <= 1'b1;
			end
			else if ((human_y >= 7'd75)&&(human_y <= 7'd79))begin
				if ((human_x >= car12_x)&&(human_x <= car12_x + 8'd8))
					crushed <= 1'b1;
			end
			else if ((human_y == car9_y)||(human_y + 1'b1 == car9_y))
			begin
				if  ((human_x >= car9_x) && (human_x <= car9_x + 1'd4))
					crushed <= 1'b1;
				if ((human_x + 1'b1 >= car9_x) && (human_x + 1'b1 <= car9_x + 1'd4))
					crushed <= 1'b1;
			end
			else if ((human_y == car10_y)||(human_y + 1'b1 == car10_y))
			begin
				if  ((human_x >= car10_x) && (human_x <= car10_x + 1'd4))
					crushed <= 1'b1;
				if ((human_x + 1'b1 >= car10_x) && (human_x + 1'b1 <= car10_x + 1'd4))
					crushed <= 1'b1;
			end
			else if ((human_x == 8'd133)&&(human_y == 7'd21))
				endgame <= 1'b1;
		end
			
		if((human_y >= 7'd60) && (human_y <= 7'd64))//at the line has car2
			begin
			if((human_x <= car2_x + 7'd16) && (human_x >= car2_x))
				crushed <= 1'b1;
			else if((human_x <= car6_x + 7'd16) && (human_x >= car6_x))
				crushed <= 1'b1;
			end
		
		if((human_y >= 7'd90) && (human_y <= 7'd94))//at the line has car3
			begin
			if((human_x <= car3_x + 7'd8) && (human_x >= car3_x))
				crushed <= 1'b1;
			else if((human_x <= car7_x + 7'd8) && (human_x >= car7_x))
				crushed <= 1'b1;
			else if((human_x <= car8_x + 7'd8) && (human_x >= car8_x))
				crushed <= 1'b1;
			end
		end
	end

endmodule
