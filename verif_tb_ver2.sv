//SHA256 project for EE287
//Group 19
//design must meet a 4.65ns cycle time

`timescale 10ns/1ns

`define tbduration 85

`define istring0 200'h5ffc9799a707e36d6008f0ebd4950cddd9c735df5ef7697fb9
`define istring1 200'h95921de9ea6670d3da1f3ff4bb8cf703c9ff175e99412607ad
`define istring2 200'h872756b6a20bb02edf0743040e1e30c9ed0248b16e2d5cabeb
`define istring3 200'h5899495319322fed157cf9c617346b4501eaf614aad1426810
`define istring4 200'h42e935b870e98d7c358a84c15cd868c2cf1d4a2b12a5f80a0a
`define istring5 200'h17b703be0e667bf78a4d9f8f5ffb5ac96628c4381836f149f5
`define istring6 200'h762a223c9f90c9ce97b5bdf073eed1118dc10e774520d780ca
`define istring7 200'hacd51e6699f9823ce16682717c9bbfae76ab14759da618fd04

`define istring00 200'h2b33bfa31b3e174eb607741867c3624916a94427d2f84ea0f
`define istring01 200'h3e0c4e145896fa19d4614180ee8121e3cc4d911b0dc27a405
`define istring02 200'h2ea613fbd67b31d729a460f6a11b92cf58440cd11776a4d157
`define istring03 200'h283c44124166c3fba8094805f0689ae11e956a7d36d288d465
`define istring04 200'h9287a0eabfe50008d80c38614452d037e4b85a4eab949606b3
`define istring05 200'h2a58cb26e7a5f1689e5fe87212b031007342a41b657a1a644d
`define istring06 200'hb039fa5868c99bd72f9ecdd454f1e8cdabc3ea49400b81c978
`define istring07 200'h382a0c2d09ba039ab87ec0d17259023bf8d07ea044f2d5a41b

`define istring10 200'h9419ee50c433af81d975f93a5ff1eeddeed4621dc481b81040
`define istring11 200'h4ac0caf4a2a116716583f3d9ff9f2cb87a7acc2c6076d18b48
`define istring12 200'ha290e3ee57a9865c7b2cec31d17176658aa25d95c13a7910f4
`define istring13 200'hb471b2e6db44062d41e6dc09f0604517eecda9473408d67f95
`define istring14 200'h25b30b0b980f7087574d4142f83480251adbd2db62e2ee229a
`define istring15 200'hbbce83d9479c75a66c1ae32996b4b0575eb712b01ad0ff9771
`define istring16 200'h12c9346d22469d4e3d69675125ff0f5a3c8204d0170778e3c1
`define istring17 200'h272ef8a588ca8e3c6bd20911b3d180223c7ff71f8021ef32f3

module perm_tb ();

reg             tb_clk;
reg             tb_reset;
reg [2:0]       tb_dix;
reg [199:0]     tb_din;
reg             tb_pushin;
wire [2:0]      tb_doutix;
wire [199:0]    tb_dout;
wire            tb_pushout;

wire [4:0][4:0][63:0] tb_debug;

perm perm0 (tb_clk, tb_reset, tb_dix, tb_din, tb_pushin, tb_doutix, tb_dout, tb_pushout, tb_debug);

initial begin
    $dumpfile("perm_wave.vcd");
    $dumpvars();
end

initial begin
    tb_clk = 0;
    repeat (`tbduration) begin
        #0.5 tb_clk = 1;
        #0.5 tb_clk = 0;
    end
end

initial begin
    tb_reset <= 1;
    tb_din <= 0;
    tb_dix <= 0;
    tb_pushin <= 0;
    #1 tb_reset <= 0;
    #1 tb_reset <= 1;

    #1 tb_pushin <= 1;
    tb_din <= 200'h60a636261;
    tb_dix <= 3'd0;
    #1 tb_din <= 200'h0;
    tb_dix <= 3'd1;
    #1 tb_dix <= 3'd2;
    #1 tb_dix <= 3'd3;
    #1 tb_dix <= 3'd4;
    #1 tb_din <= 200'h8000000000000000000000;
    tb_dix <= 3'd5;
    #1 tb_din <= 200'h0;
    tb_dix <= 3'd6;
    #1 tb_dix <= 3'd7;

    #1 tb_pushin <= 0;
    $display("For string 1");
    #8 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h\n", tb_pushout, tb_doutix, tb_dout);

    #1 tb_din <= `istring0 ;
    tb_dix <= 3'd0;
    tb_pushin <= 1;
    #1 tb_din <= `istring1 ;
    tb_dix <= 3'd1;
    #1 tb_din <= `istring2 ;
    tb_dix <= 3'd2;
    #1 tb_din <= `istring3 ;
    tb_dix <= 3'd3;
    #1 tb_din <= `istring4 ;
    tb_dix <= 3'd4;
    #1 tb_din <= `istring5 ;
    tb_dix <= 3'd5;
    #1 tb_din <= `istring6 ;
    tb_dix <= 3'd6;
    #1 tb_din <= `istring7 ;
    tb_dix <= 3'd7;

    #1 tb_pushin <= 0;
    $display("For string 2");
    #8 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h\n", tb_pushout, tb_doutix, tb_dout);

    #1 tb_pushin <= 1;
    tb_din <= `istring00;
    tb_dix <= 3'd0;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring01;
    tb_dix <= 3'd1;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring02;
    tb_dix <= 3'd2;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring03;
    tb_dix <= 3'd3;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring04;
    tb_dix <= 3'd4;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring05;
    tb_dix <= 3'd5;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring06;
    tb_dix <= 3'd6;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring07;
    tb_dix <= 3'd7;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring10;
    tb_dix <= 3'd0;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring11;
    tb_dix <= 3'd1;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring12;
    tb_dix <= 3'd2;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring13;
    tb_dix <= 3'd3;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring14;
    tb_dix <= 3'd4;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring15;
    tb_dix <= 3'd5;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring16;
    tb_dix <= 3'd6;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_din <= `istring17;
    tb_dix <= 3'd7;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 tb_pushin <= 0;
    $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
    #1 $display("push: %b %d %h", tb_pushout, tb_doutix, tb_dout);
end

endmodule  //end perm_tb
