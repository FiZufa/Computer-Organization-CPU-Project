`timescale 1ns / 1ps

module top_segment(//input rst_n,//reset: low effective
    input clk,//system clock 100MHZ 
    input rst,
    input [31:0] num,
    output wire [7:0] anode, // selection on tube 0-7
    output wire [7:0] cathode,
    output wire [7:0] cathode2

    );
   
    wire [3:0] Ones;//x
    wire [3:0] Tens;//x0
    wire [3:0] Hundreds;//x00
    wire [3:0] Thousands;//x000
    wire [3:0] TenThousands;//x0_000
    wire [3:0] HundredThousands;//x00_000
    wire [3:0] Millions; //x_000_000
    wire [3:0] TenMillions; //x0_000_000 =x000_0000
    wire clk_div;
    //manually define a new input to sixteeen bit
//    binary_BCD converter(clk, num[15:0], Ones, Tens, Hundreds,
//    Thousands, TenThousands, HundredThousands, Millions, TenMillions);
    clock_divider #(2300) clkdiv_generator (clk, clk_div); //10kHz clock signal
    
    assign Ones = num[3:0];//x
    assign Tens = num[7:4];//x0
    assign Hundreds =num[11:8];//x00
    assign Thousands =num[15:12];//x000
    assign TenThousands =num[19:16];//x0_000
    assign HundredThousands =num[23:20];//x00_000
    assign Millions =num[27:23]; //x_000_000
    assign TenMillions= num[31:28] ; //x0_000_000 =x000_0000
    
    seven_seg_controller seven_seg(.clock(clk_div),.Ones(Ones),.Tens(Tens),
    .Hundreds(Hundreds),.Thousands(Thousands),.TenThousands(TenThousands),.HundredThousands(HundredThousands),.Millions(Millions),.TenMillions(TenMillions),
    .anode(anode),.cathode(cathode), .cathode2(cathode2));  
endmodule

