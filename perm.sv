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

`define nopush 2'b00
`define yespush 2'b01
`define pbranch 2'b11

`define restart 2'b10


/*============ LEVEL 0 PERM ============*/

module perm (clk, reset, dix, din, pushin, doutix, dout, pushout);

input           clk, reset;
input  [2:0]    dix;
input  [199:0]  din;
input           pushin;
output [2:0]    doutix;
output [199:0]  dout;
output          pushout;

wire                    clk, reset, pushin, pushout;
wire [199:0]            din, dout;
wire [2:0]              dix, doutix;

wire [4:0][4:0][63:0]   data0, data1;
wire                    endofstring, endoflogic;
wire [31:0]             datatag;

inputInterface input1 (clk, reset, dix, din, pushin, data0);
permLogic logic1 (clk, reset, endofstring, data0, endoflogic, data1, datatag);
outputInterface ouput1 (clk, reset, datatag, data1, endoflogic, doutix, dout, pushout);

assign endofstring = &dix && pushin;

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

module permLogic (clk, reset, pushin, din, pushout, dout, datatag);

input                   clk, reset, pushin;
input [4:0][4:0][63:0]  din;
output                  pushout;
output [4:0][4:0][63:0] dout;
output [31:0]           datatag;

wire                    clk, reset, pushin;
wire [4:0][4:0][63:0]   din;
wire                    pushout;
wire [4:0][4:0][63:0]   dout;
reg [31:0]              datatag;

wire [4:0][4:0][63:0]   data0, data1, data2;

/*======== REGISTER UPDATE ========*/
reg [1:0]               state, nextstate;
reg [4:0][4:0][63:0]    recirculate;
reg [6:0]               ringcounter;
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
                round2 = 5'd0;
                round3 = 5'd0;
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
rho     rho0 (data0, data1);
pi      pi0 (data1, data2);
chi     chi0 (data2, data3);
iota    iota0 (data3, roundin, dout);

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



/*============ LEVEL 3 RHO ============*/
module rho(rho_in,rho_out);

input reg [4:0][4:0][63:0] rho_in;
output reg [4:0][4:0][63:0] rho_out;

reg [8:0] offset[4:0][4:0] ;

integer x,y,z;

initial begin
  offset[0][0] = 9'd0; 
  offset[0][1] = 9'd36; 
  offset[0][2] = 9'd3;
  offset[0][3] = 9'd105;
  offset[0][4] = 9'd210;
  offset[1][0] = 9'd1; 
  offset[1][1] = 9'd300; 
  offset[1][2] = 9'd10; 
  offset[1][3] = 9'd45; 
  offset[1][4] = 9'd66; 
  offset[2][0] = 9'd190; 
  offset[2][1] = 9'd6; 
  offset[2][2] = 9'd171; 
  offset[2][3] = 9'd15; 
  offset[2][4] = 9'd253; 
  offset[3][0] = 9'd28; 
  offset[3][1] = 9'd55; 
  offset[3][2] = 9'd153; 
  offset[3][3] = 9'd21; 
  offset[3][4] = 9'd120; 
  offset[4][0] = 9'd91; 
  offset[4][1] = 9'd276; 
  offset[4][2] = 9'd231; 
  offset[4][3] = 9'd136; 
  offset[4][4] = 9'd78; 
end

//Steps:
//1. For all z such that 0 ≤ z < w, let A′ [0, 0, z] = A[0, 0, z]
//2. Let (x, y) = (1, 0).
//13
//3. For t from 0 to 23:
//a. for all z such that 0 ≤ z < w, let A′[x, y, z] = A[x, y, (z – (t + 1)(t + 2)/2) mod w];
//b. let (x, y) = (y, (2x + 3y) mod 5).
//4. Return A′

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        rho_out[x][y][z] = rho_in[x][y][modulo_operation_64((z-offset[x][y]),64)];
      end 
    end
  end 
end 

function integer modulo_operation_64(input integer value,input integer modulo_value);

integer shifted_value;
integer result_value;

begin
end 

if(value == modulo_value) 
begin
  result_value = value;
end 
else 
begin
  shifted_value = value >> 6;
  shifted_value = shifted_value << 6;
  result_value  = value - shifted_value;
end
  modulo_operation_64 = result_value;
endfunction : modulo_operation_64 

endmodule 
/*============ END RHO ============*/



/*============ LEVEL 3 PI ============*/
module pi(pi_in,pi_out);

input reg [4:0][4:0][63:0] pi_in;
output reg [4:0][4:0][63:0] pi_out;

integer x,y,z;

//Steps:
//1. For all triples (x, y, z) such that 0 ≤ x < 5, 0 ≤ y < 5, and 0 ≤ z < w, let
//A′[x, y, z]= A[(x + 3y) mod 5, x, z].
//2. Return A′.

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        pi_out[x][y][z] = pi_in[modulo_operation_5_1((x+3*y),5)][x][z];
      end 
    end
  end 
end 

function integer modulo_operation_5_1(input integer value,input integer modulo_value);

if (value == modulo_value)
begin
  modulo_operation_5_1 = 0;
end
else if(value >=0 && value <5) begin
  modulo_operation_5_1 = value;
end 
else if(value >= 5 && value <10)begin
  modulo_operation_5_1 = value - 5;
end 
else if(value >= 10 && value <15)begin
  modulo_operation_5_1 = value - 10;
end 
else if(value >= 15 && value <20)begin
  modulo_operation_5_1 = value - 15;
end 
else if(value >= 20 && value <25)begin
  modulo_operation_5_1 = value - 20;
end else 
begin
  modulo_operation_5_1 = value -25;
end 


endfunction : modulo_operation_5_1 

endmodule 
/*============ END PI ============*/



/*============ LEVEL 3 CHI ============*/
module chi(chi_in,chi_out);

input reg [4:0][4:0][63:0] chi_in;
output reg [4:0][4:0][63:0] chi_out;

integer x,y,z;


//Steps:
//1. For all triples (x, y, z) such that 0 ≤ x < 5, 0 ≤ y < 5, and 0 ≤ z < w, let
//A′ [x, y, z] = A[x, y, z] ⊕ ((A[(x+1) mod 5, y, z] ⊕ 1) ⋅ A[(x+2) mod 5, y, z]).
//2. Return A′.

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        chi_out[x][y][z] = chi_in[x][y][z] ^ ((chi_in[modulo_operation_5_1(x+1,5)][y][z]) ^ 1) * chi_in[modulo_operation_5_1((x+2),5)][y][z];
      end 
    end
  end 
end 

function integer modulo_operation_5_1(input integer value,input integer modulo_value);

if (value == modulo_value)
begin
  modulo_operation_5_1 = 0;
end
else if(value >=0 && value <5) begin
  modulo_operation_5_1 = value;
end 
else if(value >= 5 && value <10)begin
  modulo_operation_5_1 = value - 5;
end 
else if(value >= 10 && value <15)begin
  modulo_operation_5_1 = value - 10;
end 
else if(value >= 15 && value <20)begin
  modulo_operation_5_1 = value - 15;
end 
else if(value >= 20 && value <25)begin
  modulo_operation_5_1 = value - 20;
end else 
begin
  modulo_operation_5_1 = value -25;
end 


endfunction : modulo_operation_5_1 

endmodule 
/*============ END CHI ============*/



/*============ LEVEL 3 IOTA ============*/
module iota (din, roundin, dout);
input [4:0][4:0][63:0]  din;
input [4:0]             roundin;
output [4:0][4:0][63:0] dout;

wire [4:0][4:0][63:0]   din;
wire [4:0]              roundin;
wire [4:0][4:0][63:0]   dout;

reg [63:0] rc;

always @ (roundin) begin
    case (roundin)
        5'd0  : rc <= 64'h0000000000000001;
        5'd1  : rc <= 64'h0000000000008082;
        5'd2  : rc <= 64'h800000000000808A;
        5'd3  : rc <= 64'h8000000080008000;
        5'd4  : rc <= 64'h000000000000808B;
        5'd5  : rc <= 64'h0000000080000001;
        5'd6  : rc <= 64'h8000000080008081;
        5'd7  : rc <= 64'h8000000000008009;
        5'd8  : rc <= 64'h000000000000008A;
        5'd9  : rc <= 64'h0000000000000088;
        5'd10 : rc <= 64'h0000000080008009;
        5'd11 : rc <= 64'h000000008000000A;
        5'd12 : rc <= 64'h000000008000808B;
        5'd13 : rc <= 64'h800000000000008B;
        5'd14 : rc <= 64'h8000000000008089;
        5'd15 : rc <= 64'h8000000000008003;
        5'd16 : rc <= 64'h8000000000008002;
        5'd17 : rc <= 64'h8000000000000080;
        5'd18 : rc <= 64'h000000000000800A;
        5'd19 : rc <= 64'h800000008000000A;
        5'd20 : rc <= 64'h8000000080008081;
        5'd21 : rc <= 64'h8000000000008080;
        5'd22 : rc <= 64'h0000000080000001;
        5'd23 : rc <= 64'h8000000080008008;
        default : rc <= 64'h0;
    endcase
end

//modify lane x=0,y=0 by rc
genvar x0, y0, z0;
generate
    for (x0=0; x0<5; x0=x0+1) begin
        for (y0=0; y0<5; y0=y0+1) begin
            if ((x0==0) && (y0==0)) begin
                for (z0=0; z0<64; z0=z0+1) begin
                    assign dout[x0][y0][z0] = din[x0][y0][z0] ^ rc[z0];
                end
            end
            else begin
                for (z0=0; z0<64; z0=z0+1) begin
                    assign dout[x0][y0][z0] = din[x0][y0][z0];
                end
            end
        end
    end
endgenerate

endmodule
/*============ END IOTA ============*/



/*============ LEVEL 1 OUTPUT_INTERFACE ============*/
module outputInterface (clk, reset, intag, din, pushin, doutix, dout, pushout);

input                   clk, reset;
input [31:0]            intag;
input [4:0][4:0][63:0]  din;
input                   pushin;
output [2:0]            doutix;
output [199:0]          dout;
output                  pushout;

wire                    clk, reset;
wire [31:0]             intag;
wire [4:0][4:0][63:0]   din;
wire                    pushin;
reg [2:0]               doutix;
reg [199:0]             dout;
wire                    pushout;

reg [1:0]       state, nextstate;
wire [2:0]      nextix;
reg [1599:0]    outreg;
reg [31:0]      datatag;


/* ======== REGISTER RESET ======== */
always @ (negedge reset) begin
    doutix <= 3'd0;
    state <= `restart ;
    outreg <= 1600'b0;
    datatag <= 32'b0;
end
/*==== END REGISTER RESET ====*/

/* ======== REGISTER UPDATE ======== */
always @ (posedge clk) begin
    state <= nextstate;

    if (pushin) begin
        outreg[319:0]     <= {din[4][0][63:0], din[3][0][63:0], din[2][0][63:0], din[1][0][63:0], din[0][0][63:0]};
        outreg[639:320]   <= {din[4][1][63:0], din[3][1][63:0], din[2][1][63:0], din[1][1][63:0], din[0][1][63:0]};
        outreg[959:640]   <= {din[4][2][63:0], din[3][2][63:0], din[2][2][63:0], din[1][2][63:0], din[0][2][63:0]};
        outreg[1279:960]  <= {din[4][3][63:0], din[3][3][63:0], din[2][3][63:0], din[1][3][63:0], din[0][3][63:0]};
        outreg[1599:1280] <= {din[4][4][63:0], din[3][4][63:0], din[2][4][63:0], din[1][4][63:0], din[0][4][63:0]};
        datatag <= intag;
    end

    if ((state == `yespush) || (state == `pbranch)) begin
        doutix <= nextix;
    end
end

assign pushout = state[0];
assign nextix = doutix + ((pushout) ? (1) : (0));
/*==== END REGISTER UPDATE ====*/

/* ======== STATE MACHINE ======== */
always @ (*) begin
    case (state)
        `nopush : begin
            if (pushin) begin
                nextstate = `yespush;
            end
            else begin
                nextstate = `nopush;
            end
        end  //end nopush

        `yespush : begin
            if (doutix == 3'd6) begin
                nextstate = `pbranch;
            end
            else begin
                nextstate = `yespush;
            end
        end  //end yespush

        `pbranch : begin
            if (pushin) begin
                nextstate = `yespush;
            end
            else begin
                nextstate = `nopush;
            end
        end  //end pbranch

        `restart : begin
            nextstate = `nopush;
        end  //end restart
    endcase
end
/*==== END STATE MACHINE ====*/

/* ======== DATAPATH ======== */
always @ (doutix or outreg) begin
    case (doutix)
        3'd0 : dout = outreg[199:0];
        3'd1 : dout = outreg[399:200];
        3'd2 : dout = outreg[599:400];
        3'd3 : dout = outreg[799:600];
        3'd4 : dout = outreg[999:800];
        3'd5 : dout = outreg[1199:1000];
        3'd6 : dout = outreg[1399:1200];
        3'd7 : dout = outreg[1599:1400];
    endcase
end
/*==== END DATAPATH ====*/

endmodule
/*============ END OUTPUT_INTERFACE ============*/
