`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// This one_image module is used to display an image of a digital 1 onto the monitor
//
//////////////////////////////////////////////////////////////////////////////////
module two_image #(parameter WIDTH = 150, HEIGHT = 150)
	(input pixel_clk,
	input [10:0] x,hcount,
	input [9:0] y,vcount,
	output reg [23:0] pixel);
	
	wire [16:0] image_addr;
	wire [7:0] image_bits, red_mapped, green_mapped, blue_mapped;
	reg [7:0] image_bits_reg;
	
	always @(posedge pixel_clk) begin
		image_bits_reg <= image_bits;
		if ((hcount-2 >= x && hcount-2 < (x+WIDTH)) && (vcount >= y && vcount < (y+HEIGHT))) begin
			pixel <= {red_mapped, green_mapped, blue_mapped};
		end
		else begin
			pixel <= 0;
		end
	end
	
	assign image_addr = (hcount-x) + (vcount-y)*WIDTH;
	two_image_rom tir2(.clka(pixel_clk),.dina(0),.addra(image_addr),.wea(0),.douta(image_bits));
	
	red_number_table rnt (.clka(pixel_clk),.dina(0),.addra(image_bits_reg),.wea(0),.douta(red_mapped));
	green_number_table gnt (.clka(pixel_clk),.dina(0),.addra(image_bits_reg),.wea(0),.douta(green_mapped));
	blue_number_table bnt (.clka(pixel_clk),.dina(0),.addra(image_bits_reg),.wea(0),.douta(blue_mapped));

endmodule
