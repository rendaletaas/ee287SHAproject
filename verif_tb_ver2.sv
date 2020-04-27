//SHA256 project for EE287
//Group 19
//design must meet a 4.65ns cycle time

`timescale 10ns/1ns
`define tbduration 50
`define istring0 200'h5ffc9799a707e36d6008f0ebd4950cddd9c735df5ef7697fb9
`define istring1 200'h95921de9ea6670d3da1f3ff4bb8cf703c9ff175e99412607ad
`define istring2 200'h872756b6a20bb02edf0743040e1e30c9ed0248b16e2d5cabeb
`define istring3 200'h5899495319322fed157cf9c617346b4501eaf614aad1426810
`define istring4 200'h42e935b870e98d7c358a84c15cd868c2cf1d4a2b12a5f80a0a
`define istring5 200'h17b703be0e667bf78a4d9f8f5ffb5ac96628c4381836f149f5
`define istring6 200'h762a223c9f90c9ce97b5bdf073eed1118dc10e774520d780ca
`define istring7 200'hacd51e6699f9823ce16682717c9bbfae76ab14759da618fd04

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
    repeat (50) begin
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

    #1 tb_din <= `istring0 ;
    tb_dix <= 3'd0;
    tb_pushin <= 1;
    display(tb_debug,"initial load", "0");
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
    display(tb_debug,"initial load","1");

end

endmodule  //end perm_tb
