`timescale 1ns / 1ps


`timescale 1ns / 1ps
/*
module executs32(
    input [31:0] Read_data_1,
    input [31:0] Read_data_2,
    input [31:0] Sign_extend,
    input [5:0] Function_opcode,
    input [5:0] Exe_opcode,
    input [1:0] ALUOp,
    input [4:0] Shamt,
    input Sftmd,
    input ALUSrc,
    input I_format,
    input Jr,
    output Zero, 
    //the ALU calculation result
    output reg [31:0] ALU_Result,
    output[31:0] Addr_Result,
    input [31:0] PC_plus_4
    );
    
    //two operands for calculation
    wire[31:0] Ainput;
    wire[31:0] Binput;
    //use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] }.
    wire[5:0] Exe_code; 
    //the control signals which affact operation in ALU directely.
    wire[2:0] ALU_ctl;
    //identify the types of shift instruction, equals to Function_opcode[2:0].
    wire[2:0] Sftm;
    //the result of shift operation.
    reg[31:0] Shift_Result;
    //the result of arithmetic or logic calculation.
    reg[31:0] ALU_output_mux;
    //the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]
    wire[32:0] Branch_Addr; 
    
    assign Ainput = Read_data_1;
    assign Sftm = Function_opcode[2:0];
    assign Binput = (ALUSrc == 0) ? Read_data_2:Sign_extend[31:0];
    assign Exe_code = (I_format == 0) ? Function_opcode:{3'b000, Exe_opcode[2:0]};
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    assign Branch_Addr = PC_plus_4 + (Sign_extend << 2);
    assign Addr_Result = Branch_Addr[31:0];
    assign Zero = (ALU_output_mux == 0) ? 1'b1 : 1'b0;
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000: ALU_output_mux = Ainput & Binput;
            3'b001: ALU_output_mux = Ainput | Binput;
            3'b010: ALU_output_mux = Ainput + Binput;
            3'b011: ALU_output_mux = Ainput + Binput;
            3'b100: ALU_output_mux = Ainput ^ Binput;
            3'b101: ALU_output_mux = ~(Ainput | Binput);
            3'b110: ALU_output_mux = Ainput - Binput;
            3'b111: ALU_output_mux = Ainput - Binput;
            default: ALU_output_mux = 32'h0000_0000;
        endcase
    end
    
    always @* begin
        if(Sftmd) begin
            case(Sftm[2:0])
                3'b000: Shift_Result = Binput << Shamt;
                3'b010: Shift_Result = Binput >> Shamt;
                3'b100: Shift_Result = Binput << Ainput;
                3'b110: Shift_Result = Binput >> Ainput;
                3'b011: Shift_Result = $signed(Binput) >>> Shamt;
                3'b111: Shift_Result = $signed(Binput) >>> Ainput;
                default: Shift_Result = Binput;
            endcase
        end
        else begin
            Shift_Result = Binput;
        end
    end
    
    always @* begin
        //set type operation (slt, slti, sltu, sltiu)
        if (((ALU_ctl==3'b111) && (Exe_code[3]==1)) || ((ALU_ctl[2:1]==2'b11) && (I_format==1)))
            ALU_Result = (ALU_output_mux[31] == 1) ? 1'b1 : 1'b0;
        //lui operation
        else if ((ALU_ctl==3'b101) && (I_format==1))
            ALU_Result = {Binput[15:0] , 16'h0000};
        //shift operation
        else if(Sftmd==1)
            ALU_Result = Shift_Result;
        //other types of operation in ALU (arithmatic or logic calculation)
        else
            ALU_Result = ALU_output_mux[31:0];
    end
    
endmodule
*/

module executs32(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
                 Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4
                 );
    //from decoder
    input[31:0]  Read_data_1;		// �����뵥Ԫ��Read_data_1����
    input[31:0]  Read_data_2;		// �����뵥Ԫ��Read_data_2����
    input[31:0]  Sign_extend;   	// �����뵥Ԫ������չ���������
    //from ifetch
    input[5:0]   Function_opcode;  	// ȡָ��Ԫ����r-����ָ�����,r-form instructions[5:0]
    input[31:0]  PC_plus_4;         // ����ȡָ��Ԫ��PC+4
    input[4:0]   Shamt;             // ����ȡָ��Ԫ��instruction[10:6]��ָ����λ����
    input[5:0]   Exe_opcode;  		// ȡָ��Ԫ���Ĳ�����
    //from controller
    input[1:0]   ALUOp;             // ���Կ��Ƶ�Ԫ������ָ����Ʊ���
    input  		 Sftmd;             // ���Կ��Ƶ�Ԫ�ģ���������λָ��
    input        ALUSrc;            // ���Կ��Ƶ�Ԫ�������ڶ�������������������beq��bne���⣩
    input        I_format;          // ���Կ��Ƶ�Ԫ�������ǳ�beq, bne, LW, SW֮���I-����ָ��
    input        Jr;                // ���Կ��Ƶ�Ԫ��������JRָ��
    //output
    output Zero;                // Ϊ1��������ֵΪ0 
    output reg [31:0]  ALU_Result;        // ��������ݽ��
    output [31:0] Addr_Result;		 // ����ĵ�ַ���        

    //��������
    wire [31:0] Ainput;
    wire [31:0] Binput;
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];

    //alu_ctl
    wire [5:0] Exe_code;
    assign Exe_code = (I_format == 0) ? Function_opcode : { 3'b000 , Exe_opcode[2:0] };
    wire [2:0] ALU_ctl;
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];

    //
    reg signed [31:0] AlU_output_mux;
    always @(ALU_ctl or Ainput or Binput) begin
        case (ALU_ctl)
            3'b000:AlU_output_mux = Ainput & Binput;//and andi
            3'b001:AlU_output_mux = Ainput | Binput;//or ori
            3'b010:AlU_output_mux = $signed(Ainput) + $signed(Binput);//add addi lw sw
            3'b011:AlU_output_mux = Ainput + Binput;//addu addiu
            3'b100:AlU_output_mux = Ainput ^ Binput;//xor xori
            3'b101:AlU_output_mux = ~(Ainput | Binput);//nor lui
            3'b110:AlU_output_mux = $signed(Ainput) - $signed(Binput);//sub slti beq bne
            3'b111:AlU_output_mux = Ainput - Binput;//subu sltiu slt sltu
            default: AlU_output_mux = 32'h0000_0000;
        endcase
    end

    wire[2:0] Sftm;
    assign Sftm = Function_opcode[2:0]; //the code of shift operations 
    reg[31:0] Shift_Result; //the result of shift operation
    always @* begin // six types of shift instructions 
        if(Sftmd) begin
            case(Sftm[2:0]) 
                3'b000:Shift_Result = Binput << Shamt;        //Sll rd,rt,shamt 00000 
                3'b010:Shift_Result = Binput >> Shamt;        //Srl rd,rt,shamt 00010 
                3'b100:Shift_Result = Binput << Ainput;       //Sllv rd,rt,rs 00010 
                3'b110:Shift_Result = Binput >> Ainput;       //Srlv rd,rt,rs 00110 
                3'b011:Shift_Result = $signed(Binput) >>> Shamt;//Sra rd,rt,shamt 00011 
                3'b111:Shift_Result = $signed(Binput) >>> Ainput;//Srav rd,rt,rs 00111 
                default:Shift_Result = Binput; 
            endcase 
        end
        else begin 
            Shift_Result = Binput;
        end
    end

    always @* begin 
        if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1)) ||((ALU_ctl == 3'b110) && (Exe_opcode == 6'b001010))|| ((ALU_ctl == 3'b111) && (Exe_opcode == 6'b001011))) begin
            ALU_Result = (AlU_output_mux[31] == 1)? 1 : 0; //set type operation (slt, slti, sltu, sltiu)
        end
        else if((ALU_ctl == 3'b101) && (I_format == 1)) begin
            ALU_Result = {Binput[15:0],16'b0};  //lui operation 
        end
        else if(Sftmd == 1) begin
            ALU_Result = Shift_Result; //shift operation
        end
        else begin
            ALU_Result = AlU_output_mux;//other types of operation in ALU (arithmatic or logic calculation)
        end
    end

    assign Zero = (AlU_output_mux == 32'b0)? 1 : 0;
    assign Addr_Result = PC_plus_4 + (Sign_extend << 2);
endmodule


