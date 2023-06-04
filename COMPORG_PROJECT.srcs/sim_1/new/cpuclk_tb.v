`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2023 05:58:34 AM
// Design Name: 
// Module Name: cpuclk_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpuclk_tb();
reg clkin;
 reg rst;
   reg syscall;
   reg [7:0] input8bit;
   wire [7:0] seg_out0, seg_out1;
   wire [7:0] seg_en;
   wire led_out;
wire clkout;

//cpuclk clk1( .clk_in1(clkin), .clk_out1(clkout) );
CPU cpu1(
    .syscall(syscall), .clk(clkin),.rst(rst),.input8bit(input8bit),.seg_out0(seg_out0),.seg_out1(seg_out1),.seg_en(seg_en),.led_out(led_out));
initial 
begin
input8bit = 8'b00000000;
clkin = 1'b0;
 rst = 1'b1;
 syscall =1'b0;
 #10
 rst = 1'b1;
 #100
  rst = 1'b0;
  #12100
  syscall =1'b1;
  #12101
  syscall =1'b0;
end

always #5 clkin=~clkin;
endmodule
