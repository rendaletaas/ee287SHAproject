`define empty 2'b00
`define firstpush 2'b01
`define full 2'b11
`define restart 2'b10


/*============ LEVEL 0 PERM ============*/

module perm (clk, reset, dix, din, pushin, doutix, dout, pushout, debugtap);

input           clk, reset;
input  [2:0]    dix;
input  [199:0]  din;
input           pushin;
output [2:0]    doutix;
output [199:0]  dout;
output          pushout;

output [4:0][4:0][63:0] debugtap;

wire                    clk, reset, pushin, pushout;
wire [199:0]            din, dout;
wire [2:0]              dix, doutix;

wire [4:0][4:0][63:0]   data0, data1;
wire endofstring, endoflogic;

inputInterface input1 (clk, reset, dix, din, pushin, data0);
permLogic logic1 (clk, reset, endofstring, data0, endoflogic, data1);

assign endofstring = &din && pushin;

assign debugtap = data0;

endmodule  //end perm

/*============ LEVEL 1 INPUT_INTERFACE ============*/

module inputInterface (clk, reset, dix, din, pushin, dout);

input                   clk, reset;
input [2:0]             dix;
input [199:0]           din;
input                   pushin;
output [4:0][4:0][63:0] dout;

wire                    clk, reset, pushin;
wire [2:0]              dix;
wire [199:0]            din;
reg [4:0][4:0][63:0]    dout;

/*======== RESET ========*/
integer ireset [2:0];
always @ (negedge reset) begin
    for (ireset[2]=0; ireset[2]<5; ireset[2]=ireset[2]+1) begin
        for (ireset[1]=0; ireset[1]<5; ireset[1]=ireset[1]+1) begin
            for (ireset[0]=0; ireset[0]<64; ireset[0]=ireset[0]+1) begin
                dout[ireset[2]][ireset[1]][ireset[0]] <= 0;
            end
        end
    end
end
/*==== END RESET ====*/

/*======== DATA LOADING ========*/
always @ (posedge clk) begin
    case (dix)
        3'b000 : begin
            if (pushin) begin
                dout[0][0][63:0] <= din[63:0];
                dout[1][0][63:0] <= din[127:64];
                dout[2][0][63:0] <= din[191:128];
                dout[3][0][7:0]  <= din[199:192];
            end
        end
        3'b001 : begin
            if (pushin) begin
                dout[3][0][63:8] <= din[55:0];
                dout[4][0][63:0] <= din[119:56];
                dout[0][1][63:0] <= din[183:120];
                dout[1][1][15:0] <= din[199:184];
            end
        end
        3'b010 : begin
            if (pushin) begin
                dout[1][1][63:16] <= din[47:0];
                dout[2][1][63:0]  <= din[111:48];
                dout[3][1][63:0]  <= din[175:112];
                dout[4][1][23:0]  <= din[199:176];
            end
        end
        3'b011 : begin
            if (pushin) begin
                dout[4][1][63:24] <= din[39:0];
                dout[0][2][63:0]  <= din[103:40];
                dout[1][2][63:0]  <= din[167:104];
                dout[2][2][31:0]  <= din[199:168];
            end
        end
        3'b100 : begin
            if (pushin) begin
                dout[2][2][63:32] <= din[31:0];
                dout[3][2][63:0]  <= din[95:32];
                dout[4][2][63:0]  <= din[159:96];
                dout[0][3][39:0]  <= din[199:160];
            end
        end
        3'b101 : begin
            if (pushin) begin
                dout[0][3][63:40] <= din[23:0];
                dout[1][3][63:0]  <= din[87:24];
                dout[2][3][63:0]  <= din[151:88];
                dout[3][3][47:0]  <= din[199:152];
            end
        end
        3'b110 : begin
            if (pushin) begin
                dout[3][3][63:48] <= din[15:0];
                dout[4][3][63:0]  <= din[79:16];
                dout[0][4][63:0]  <= din[143:80];
                dout[1][4][55:0]  <= din[199:144];
            end
        end
        3'b111 : begin
            if (pushin) begin
                dout[1][4][63:56] <= din[7:0];
                dout[2][4][63:0]  <= din[71:8];
                dout[3][4][63:0]  <= din[135:72];
                dout[4][4][63:0]  <= din[199:136];
            end
        end
    endcase
end
/*==== END DATA LOADING ====*/

endmodule
/*============ END INPUT_INTERFACE ============*/

/*============ LEVEL 1 PERM_LOGIC ============*/
module permLogic (clk, reset, pushin, din, pushout, dout);

input                   clk, reset, pushin;
input [4:0][4:0][63:0]  din;
output                  pushout;
output [4:0][4:0][63:0] dout;

wire                    clk, reset, pushin;
wire [4:0][4:0][63:0]   din;
wire                    pushout;
wire [4:0][4:0][63:0]   dout;

/*======== REGISTER UPDATE ========*/
reg [1:0]               state, nextstate;
reg [4:0][4:0][63:0]    recirculate;
always @ (posedge clk) begin
    state <= nextstate;
    if ((state == `firstpush) || (state == `full)) begin
        recirculate <= dout;
    end
    
end
/*==== END REGISTER UPDATE ====*/

/*======== STATE MACHINE ========*/



endmodule  //end permLogic
