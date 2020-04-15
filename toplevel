module perm(clk, reset, dix, din, pushin, doutix, dout, pushout)
    input          clk, reset, pushin;
    input  [2:0]   dix;
    input  [199:0] din;
    output [2:0]   doutix;
    output [199:0] dout;
    output         pushout;
    
    wire         clk, reset, pushin, pushout, push0;
    wire [199:0] din, dout, data0, data1;
    wire [2:0]   dix, dout;
    wire [7:0]   tag0, tag1;
    
    inputInterface  block0 (.din(din), .dix(dix), .pushin(pushin), .clk(clk), .reset(reset), .dout(data0), .tagout(tag0));
    permLogic       block1 (.din(data0), .dix(dix), .pushin(pushin), .clk(clk), .reset(reset), .dout(data1), .tagout(tag1), .tagin(tag0), .pushout(push0));
    outputInterface block2 (.din(data1), .pushin(push0), .clk(clk), .reset(reset), .dout(dout), .tagin(tag1), .pushout(pushout);
endmodule
