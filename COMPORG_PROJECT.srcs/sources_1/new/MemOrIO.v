`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2023 05:16:48 AM
// Design Name: 
// Module Name: MemOrIO
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


module MemOrIO(mRead, mWrite, ioRead, ioWrite, addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl);

input mRead; //read memory from controller
input mWrite; // write memory, from controller
input ioRead; //read IO, from controller
input ioWrite; //write IO, from controller

input[31:0] addr_in; //from alu_result in ALU
output[31:0] addr_out; //address to Data-Memory

input[31:0] m_rdata; //data read from Data-Memory
input[15:0] io_rdata; //data read from IO, 16 bits
output[31:0] r_wdata; //data to Decoder(register file)

input[31:0] r_rdata; //data read from decoder(register file)
output reg[31:0] write_data; //data to memory or I/O (m_wdata, io_wdata)
output LEDCtrl; //LED chip select
output SwitchCtrl;

assign addr_out = addr_in;
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit
assign r_wdata = (mRead == 1)? m_rdata:{{16{io_rdata[15]}},io_rdata};
// Chip select signal of Led and Switch are all active high
assign LEDCtrl = (ioWrite == 1'b1&& addr_in[7:4]==4'b0110) ? 1'b1 : 1'b0;
assign SwitchCtrl= (ioRead == 1'b1 && addr_in[7:4]==4'h7) ? 1'b1 : 1'b0;


always @*begin
	if((mWrite==1)||(ioWrite==1))
		//write_data could go to either memory or IO. where is it from?
			write_data = r_rdata;
	else
		write_data=32'hZZZZZZZZ;
end

endmodule


//referenced : lab11
