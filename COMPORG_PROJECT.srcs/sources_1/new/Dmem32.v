`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 11:07:45 PM
// Design Name: 
// Module Name: Dmem32
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


module Dmem32(read_data,address,write_data,Memwrite,clock);
output[31:0] read_data;
input[31:0] address;
input[31:0] write_data;  
input Memwrite; 
input clock;
endmodule
