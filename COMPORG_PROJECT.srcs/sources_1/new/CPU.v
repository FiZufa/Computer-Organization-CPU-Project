`timescale 1ns / 1ps

module CPU(
    input clk,
    input rst,
    input syscall,
    input [7:0] input8bit,
    output [7:0] seg_out0, seg_out1,
    output [7:0] seg_en,
    output led_out,
      output led_val,
       output syscall_led
    );
        wire s7;

    assign led_out = input8bit[0:0];
    assign led_val = s7;
    wire Branch,nBranch,Jmp,Jal,Jrn,Zero; 
    wire clock;
    wire writesyscall;
    wire [31:0]Instruction; 
    wire [31:0]PC_plus_4_out; 
    wire [31:0] branch_base_addr;
    wire [31:0]Add_Result; 
    wire [31:0]Read_data_1; 
    wire [31:0]opcplus4; 
   wire [31:0] next_PC;
    wire [31:0]PC;
    
    wire [31:0] Read_data_2; 
    wire [31:0] read_data; 
    wire RegWrite; 
    wire RegDst; 
    wire [31:0]Sign_extend; 
    assign syscall_led = writesyscall;  
    wire ALUSrc; 
    wire MemtoReg; 
    wire MemRead; 
    wire MemWrite; 
    wire IORead;
    wire IOWrite;
    wire I_format;
    wire Sftmd; 
    wire [1:0]ALUOp; 
    
    wire [4:0]Shamt;
    wire [31:0]ALU_Result; 
     wire [31:0]t7res; 
    wire[31:0] address; 
    wire switchcs;
    wire [1:0]switchaddr; 
    wire [15:0]switchrdata; 
    wire [23:0]switch_i;
    
    wire cpu_clock_slow;
   freq_div freqdiv(clock,cpu_clock_slow); //simul comment
   //assign cpu_clock_slow = clock;
    
    cpuclk cpuclock(
    .clk_in1(clk),
    .clk_out1(clock)
    );
    
    Ifetc32 ifetch(
    .Instruction(Instruction),.branch_base_addr(branch_base_addr),.Addr_result(Add_Result),.Read_data_1(Read_data_1),.Branch(Branch),.nBranch(nBranch),
    .Jmp(Jmp),.Jal(Jal),.Jr(Jrn),.Zero(Zero),.clock(cpu_clock_slow),.reset(rst),.link_addr(opcplus4),.syscall(syscall),.writesyscall(writesyscall),.PC_plus_4_out(PC_plus_4_out)
    );
    
    decode32 decoder(
    .read_data_1(Read_data_1),.read_data_2(Read_data_2),.Instruction(Instruction),.mem_data(read_data),.ALU_result(ALU_Result),.input8bit(input8bit),
    .Jal(Jal),.RegWrite(RegWrite),.MemtoReg(MemtoReg),.RegDst(RegDst),.Sign_extend(Sign_extend),.clock(cpu_clock_slow),.reset(rst),.opcplus4(opcplus4),.writesyscall(writesyscall),.t7res(t7res),.s7(s7)
    );
    
    //IORead IOWrite???
    control32 controller(
    .Opcode(Instruction[31:26]), .Function_opcode(Instruction[5:0]), .Jr(Jrn), .RegDST(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),
    .RegWrite(RegWrite), .MemWrite(MemWrite), .Branch(Branch), .nBranch(nBranch), .Jmp(Jmp), .Jal(Jal), .I_format(I_format),
    .Sftmd(Sftmd), .ALUOp(ALUOp)
    );
    
    executs32 ALU(
    .Read_data_1(Read_data_1),.Read_data_2(Read_data_2),.Sign_extend(Sign_extend),.Function_opcode(Instruction[5:0]),
    .Exe_opcode(Instruction[31:26]),.ALUOp(ALUOp),.Shamt(Instruction[10:6]),.ALUSrc(ALUSrc),.I_format(I_format),
    .Zero(Zero),.Jr(Jrn),.Sftmd(Sftmd),.ALU_Result(ALU_Result),.Addr_Result(Add_Result),.PC_plus_4(PC_plus_4_out)                    
    );
    
    dmemory32 dmem(
    .clock(cpu_clock_slow), .memWrite(MemWrite), .address(ALU_Result[15:2]), .writeData(Read_data_2), .readData(read_data)
    );
    
    top_segment mileage_record(
       .clk(clock),
       .rst(rst),
       .num(t7res),
       .anode(seg_en),
       .cathode(seg_out0),
       .cathode2(seg_out1)
       );

    
   
    
endmodule

// referenced : lab13 UART