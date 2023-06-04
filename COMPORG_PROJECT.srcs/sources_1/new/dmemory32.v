`timescale 1ns / 1ps


module dmemory32(clock, memWrite, address, writeData, readData);
    input clock;   //Clock signal for synchronization
    input memWrite;  //From controller. 1'b1 indicates write operations to data-memory.
										// indicating whether a write operation should be performed on D-mem
    input [15:2] address;  //The unit is byte. 
														//The address of memory unit which is to be read/writen.
    input [31:0] writeData; //Data to be written to the memory unit.
    output[31:0] readData;  //Data read from memory unit.
   
   wire clk;
   assign clk = !clock;
		// Memory IP instanced
		/* ram module represents the data memory unit and is responsible for performing the 
		actual read and write operations on the memory which has following connections:
		*/
		RAM ram (
			.clka(clk), // input wire clka -> clock signal for memory unit
			.wea(memWrite), // input wire [0 : 0] wea -> write enable signal connected 
											// to 'memWrite' indicating whether operation should be performed
			.addra(address), // input wire [13 : 0] addra
														// the address signal for the memory unit
			.dina(writeData), // input wire [31 : 0] dina -> input data signal for memory unit
			.douta(readData) // output wire [31 : 0] douta ->output data signal from the 
											// memory unit
		);
	
	/*The 'clock' is from CPU-TOP, suppose its one edge has been used at the upstream module of data memory, suchas IFetch, Why Data-Memroy DO NOT use the same edge as other module ? */

endmodule

// reference : lab10 and lab 13

