`timescale 1ns / 1ps


module Ifetc32 (Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,
				Jmp,Jal,Jr,Zero,clock,reset,link_addr,syscall,writesyscall,PC_plus_4_out);
    output[31:0] Instruction;	// the instruction fetched from this module
    output[31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
		//the base address for branch instructions, which is PC+4
    output reg[31:0] link_addr; // (pc+4) to Decoder which is used by jal instruction
    output reg writesyscall;
		//from ALU
    input[31:0]  Addr_result;// the calculated address from ALU
		input        Zero; // while Zero is 1, it means the ALUresult is zero

		//from Decoder
    input[31:0]  Read_data_1; // the address of instruction used by jr instruction
    output[31:0] PC_plus_4_out;
		//from decoder
    input        Branch; // while Branch is 1,it means current instruction is beq -> I-type
    input        nBranch; // while nBranch is 1,it means current instruction is bnq/non-branch
    input        Jmp; // while Jmp 1, it means current instruction is jump -> J-type
    input        Jal; // while Jal is 1, it means current instruction is jal -> J-type
    input        Jr; // while Jr is 1, it means current instruction is jr -> R-type

		//from CPU TOP
    input        clock,reset;// Clock and reset (Synchronous reset signal, 
														//high level is effective, when reset=1, PC value is 0)
    
		wire need_input;
		reg[31:0] PC, Next_PC; // register representing the program counter and 
													// the next program counter value
		
		assign branch_base_addr = PC + 4 ; 
        input syscall;
		// instance the IP core : Block memory
		// fetching instructions from memory based on current value of the PC register 
		prgrom instmem(
			.clka(clock), 
			.addra(PC[15:2]),
			.douta(Instruction)
		);
	
		assign PC_plus_4_out = PC+4;
		always @*begin
			if(((Branch==1)&&(Zero==1)) || ((nBranch==1)&&(Zero==0))) // beq, bne
				Next_PC = Addr_result; // the calculated new value for PC
			else if(Jr==1)
				Next_PC = Read_data_1; // the value of $31 register
			else if(syscall == 0 && Instruction ==  32'h0000_000c)
			begin
			    Next_PC = PC;
			    writesyscall = 1'b1;
			    end
			else
			     begin
			     writesyscall = 1'b0;
			     Next_PC = PC+4;
			     end
			
		end

	always @(negedge clock) begin
		if (reset == 1) begin
			PC <= 32'h0000_0000;
		end
		else if ((Jmp==1) || (Jal==1)) begin
							link_addr <= Next_PC ;
					PC <= {PC[31:28], Instruction[25:0], 2'b00};
		
		end
			else begin
				PC <= Next_PC;
			end
		end

        
endmodule

// referenced : in slide lab10

