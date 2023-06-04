`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2023 09:00:23 PM
// Design Name: 
// Module Name: IFetch32
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


module IFetch32(Instruction,PC_plus_4_out,Add_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jrn,Zero,clock,reset,opcplus4,next_PC,PC);
    output[31:0] Instruction;			
    output[31:0] PC_plus_4_out;        
    input[31:0]  Add_result;            
    input[31:0]  Read_data_1;           
    input        Branch;               
    input        nBranch;               
    input        Jmp;                   
    input        Jal;                   
    input        Jrn;                   
    input        Zero;                  
    input        clock,reset;          
    output[31:0] opcplus4;              
    output [31:0]next_PC;
    output [31:0] PC;
    wire[32:0]   PC_plus_4;             
    reg[31:0]	  PC;                  
    reg[31:0]    next_PC;              
    reg[31:0]    opcplus4;
    
    prgrom instmem(
        .clka(clock),        
        .addra(PC[15:2]),     
        .douta(Instruction)         
    );
    
 assign PC_plus_4[31:2] = PC[31:2] + 1'b1;
      assign PC_plus_4[1:0] =PC[1:0];
   assign PC_plus_4_out = PC_plus_4[31:0];
  
always @* begin  // beq $n ,$m if $n=$m branch   bne if $n /=$m branch jr
       if(Jrn == 1'b1)begin
           next_PC = Read_data_1;
       end
       else if((Branch == 1'b1 && Zero == 1'b1)||(nBranch == 1'b1 && Zero == 1'b0))
       begin
            next_PC = Add_result;
       end
       else begin
               next_PC = PC_plus_4[31:2];
       end
   end
 
      always @(negedge clock) begin  
         if(reset == 1'b1)begin
                 PC = 32'h00000000;
         end
         else if(Jmp == 1'b1 || Jal == 1'b1)begin
             opcplus4 = next_PC;
             PC = {PC[31:28],Instruction[27:0]<<2};
         end
         else begin
         PC = next_PC<<2;        
         //PC = next_PC << 2;
         end
     end
endmodule
