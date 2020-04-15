module perm(clk, reset, dix, din, pushin, doutix, dout, pushout)
    input          clk, reset, pushin;
    input  [2:0]   dix;
    input  [199:0] din;
    output [2:0]   doutix;
    output [199:0] dout;
    output         pushout;
    
    wire          clk, reset, pushin, pushout, push0;
    wire [199:0]  din, dout;
    wire [1599:0] data0, data1;
    wire [2:0]    dix, dout;
    wire [7:0]    tag;
    
    inputInterface  block0 (.din(din), .dix(dix), .pushin(pushin), .clk(clk), .reset(reset), .dout(data0));
    permLogic       block1 (.din(data0), .dix(dix), .pushin(pushin), .clk(clk), .reset(reset), .dout(data1), .tagout(tag), .pushout(push0));
    outputInterface block2 (.din(data1), .pushin(push0), .clk(clk), .reset(reset), .dout(dout), .tagin(tag), .pushout(pushout);
endmodule
