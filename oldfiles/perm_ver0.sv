//LEVEL 0 PERM
// LEVEL 1 INPUT_INTERFACE
// LEVEL 1 PERM_LOGIC
//  LEVEL 2 PERM_LAYER
//   LEVEL 3 THETA
//   LEVEL 3 RHO
//   LEVEL 3 PI
//   LEVEL 3 CHI
//   LEVEL 3 IOTA
// LEVEL 1 OUTPUT_INTERFACE

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

assign endofstring = &dix && pushin;

assign debugtap = data1;

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

wire [4:0][4:0][63:0]   data0, data1, data2;

/*======== REGISTER UPDATE ========*/
reg [1:0]               state, nextstate;
reg [4:0][4:0][63:0]    recirculate;
reg [6:0]               ringcounter;
reg [31:0]              datatag;
always @ (posedge clk) begin
    state <= nextstate;
    if ((state == `firstpush) || (state == `full)) begin
        recirculate <= dout;
    end
    if (state == `firstpush) begin
        datatag[31:28] <= din[4][4][63:60];
        datatag[27:24] <= din[1][4][55:52];
        datatag[23:20] <= din[3][3][47:44];
        datatag[19:16] <= din[0][3][39:36];
        datatag[15:12] <= din[2][2][31:28];
        datatag[11:8] <=  din[4][1][23:20];
        datatag[7:4] <=   din[1][1][15:12];
        datatag[3:0] <=   din[3][0][7:4];
    end
    if (state == `full) begin
        ringcounter[0] <= ringcounter[6];
        ringcounter[1] <= ringcounter[0];
        ringcounter[2] <= ringcounter[1];
        ringcounter[3] <= ringcounter[2];
        ringcounter[4] <= ringcounter[3];
        ringcounter[5] <= ringcounter[4];
        ringcounter[6] <= ringcounter[5];
    end
end
/*==== END REGISTER UPDATE ====*/

/*======== RESET ========*/
integer i;
always @ (negedge reset) begin
    state <= `restart ;
    recirculate <= 200'b0;
    datatag <= 32'b0;
    for(i=1;i<7;i=i+1) begin
        ringcounter[i] <= 1'b0;
    end
    ringcounter[0] <= 1'b1;
end
/*==== END RESET ====*/

/*======== STATE MACHINE ========*/
always @ (*) begin
    case (state)
        `empty : begin
            if (pushin) begin
                nextstate = `firstpush;
            end
            else begin
                nextstate = `empty;
            end
        end  //end empty

        `firstpush : begin
            nextstate = `full;
        end  //end firstpush

        `full : begin
            if (~ringcounter[6]) begin
                nextstate = `full;
            end
            else begin
                if (pushin) begin
                    nextstate = `firstpush;
                end
                else begin
                    nextstate = `empty;
                end
            end
        end  //end full

        `restart : begin
            nextstate = `empty;
        end  //end restart
    endcase
end
/*==== END STATE MACHINE ====*/

/*======== ROUND SETTER ========*/
reg [4:0] round1, round2, round3;
always @ (*) begin
    if (state == `firstpush) begin
        round1 = 5'd0;
        round2 = 5'd1;
        round3 = 5'd2;
    end
    else begin
        case (ringcounter)
            7'b0000001 : begin
                round1 = 5'd3;
                round2 = 5'd4;
                round3 = 5'd5;
            end
            7'b0000010 : begin
                round1 = 5'd6;
                round2 = 5'd7;
                round3 = 5'd8;
            end
            7'b0000100 : begin
                round1 = 5'd9;
                round2 = 5'd10;
                round3 = 5'd11;
            end
            7'b0001000 : begin
                round1 = 5'd12;
                round2 = 5'd13;
                round3 = 5'd14;
            end
            7'b0010000 : begin
                round1 = 5'd15;
                round2 = 5'd16;
                round3 = 5'd17;
            end
            7'b0100000 : begin
                round1 = 5'd18;
                round2 = 5'd19;
                round3 = 5'd20;
            end
            7'b1000000 : begin
                round1 = 5'd21;
                round2 = 5'd22;
                round3 = 5'd23;
            end
            default : begin
                round1 = 5'd0;
                round2 = 5'd1;
                round3 = 5'd2;
            end
        endcase
    end
end
/*==== END ROUND SETTER ====*/

/*======== DATAPATH ========*/
assign pushout = ringcounter[6];
assign data0 = (state == `firstpush) ? (din) : (recirculate);
permLayer layer_one2 (data0, round1, data1);
permLayer layer_two2 (data1, round2, data2);
permLayer layer_thr2 (data2, round3, dout);
/*==== END DATAPATH ====*/

endmodule
/*============ END PERM_LOGIC ============*/



/*============ LEVEL 2 PERM_LAYER ============*/
module permLayer (din, roundin, dout);

input [4:0][4:0][63:0]  din;
input [4:0]             roundin;
output [4:0][4:0][63:0] dout;

wire [4:0][4:0][63:0]   din;
wire [4:0]              roundin;
wire [4:0][4:0][63:0]   dout;

wire [4:0][4:0][63:0]   data0, data1, data2, data3;

theta   theta0 (din, data0);
//rho     rho0 (data0, data1);
//pi      pi0 (data1, data2);
//chi     chi0 (data2, data3);
//iota    iota0 (data3, roundin, dout);
assign dout = data0;


endmodule
/*============ END PERM_LAYER ============*/



/*============ LEVEL 3 THETA ============*/
module theta(theta_in,theta_out);

input reg [4:0][4:0][63:0] theta_in;
output reg [4:0] [4:0] [63:0] theta_out;

reg [4:0][63:0] C,D;

integer x,y,z;

always @(*)
begin
  // STEP : 1
  // For all pairs (x, z) such that 0 ≤ x < 5 and 0 ≤ z < w, let
  // C[x, z] = A[x, 0, z] ⊕ A[x, 1, z] ⊕ A[x, 2, z] ⊕ A[x, 3, z] ⊕ A[x, 4, z].

  // STEP : 2
  //For all pairs (x, z) such that 0 ≤ x < 5 and 0 ≤ z < w let
  //D[x, z] = C[(x-1) mod 5, z] ⊕ C[(x+1) mod 5, (z – 1) mod w].
  for(x=0; x<5 ; x=x+1)
  begin
    for(z=0 ; z<64 ; z=z+1)
    begin
      C[x][z] = theta_in[x][0][z] ^ theta_in[x][1][z] ^ theta_in[x][2][z] ^ theta_in[x][3][z] ^ theta_in[x][4][z];
      D[x][z] = C[modulo_operation_5(x-1,5)][z] ^ C[modulo_operation_5(x+1,5)] [modulo_operation_5(z-1,64)];
    end 
  end 

  // STEP : 3
  //For all triples (x, y, z) such that 0 ≤ x < 5, 0 ≤ y < 5, and 0 ≤ z < w, let
  //A′[x, y, z] = A[x, y, z] ⊕ D[x, z].

  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        theta_out[x][y][z] = theta_in[x][y][z] ^ D[x][z];
      end 
    end
  end 
end 

function integer modulo_operation_5(input integer value,input integer modulo_value);

if (value == modulo_value)
begin
  modulo_operation_5 = 0;
end
else if (value < 0)
begin
  modulo_operation_5 = modulo_value + value;
end
else begin
  modulo_operation_5 = value;
end 

endfunction : modulo_operation_5 

endmodule
/*============ END THETA ============*/


