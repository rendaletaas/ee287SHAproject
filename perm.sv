//Use ctrl+f to find a module in the code
//For example: ctrl+f "LEVEL 3 RHO"
//LEVEL 0 PERM
//    LEVEL 1 INPUT_INTERFACE
//    LEVEL 1 PERM_LOGIC
//        LEVEL 2 PERM_LAYER
//            LEVEL 3 THETA
//            LEVEL 3 RHO
//            LEVEL 3 PI
//            LEVEL 3 CHI
//            LEVEL 3 IOTA
//    LEVEL 1 OUTPUT_INTERFACE

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

endmodule
/*============ END PERM ============*/



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

integer ireset [2:0];

/*======== DATA LOADING ========*/
always @ (posedge clk or posedge reset) begin
  if(reset == 1) begin 
    for (ireset[2]=0; ireset[2]<5; ireset[2]=ireset[2]+1) begin
        for (ireset[1]=0; ireset[1]<5; ireset[1]=ireset[1]+1) begin
            for (ireset[0]=0; ireset[0]<64; ireset[0]=ireset[0]+1) begin
                dout[ireset[2]][ireset[1]][ireset[0]] <= 0;
            end
        end
    end
  end
  else begin  //~reset
    case (dix)
        3'b000 : begin
            if (pushin) begin
                dout[0][0][63:0] <= #1 din[63:0];
                dout[1][0][63:0] <= #1 din[127:64];
                dout[2][0][63:0] <= #1 din[191:128];
                dout[3][0][7:0]  <= #1 din[199:192];
            end
        end
        3'b001 : begin
            if (pushin) begin
                dout[3][0][63:8] <= #1 din[55:0];
                dout[4][0][63:0] <= #1 din[119:56];
                dout[0][1][63:0] <= #1 din[183:120];
                dout[1][1][15:0] <= #1 din[199:184];
            end
        end
        3'b010 : begin
            if (pushin) begin
                dout[1][1][63:16] <= #1 din[47:0];
                dout[2][1][63:0]  <= #1 din[111:48];
                dout[3][1][63:0]  <= #1 din[175:112];
                dout[4][1][23:0]  <= #1 din[199:176];
            end
        end
        3'b011 : begin
            if (pushin) begin
                dout[4][1][63:24] <= #1 din[39:0];
                dout[0][2][63:0]  <= #1 din[103:40];
                dout[1][2][63:0]  <= #1 din[167:104];
                dout[2][2][31:0]  <= #1 din[199:168];
            end
        end
        3'b100 : begin
            if (pushin) begin
                dout[2][2][63:32] <= #1 din[31:0];
                dout[3][2][63:0]  <= #1 din[95:32];
                dout[4][2][63:0]  <= #1 din[159:96];
                dout[0][3][39:0]  <= #1 din[199:160];
            end
        end
        3'b101 : begin
            if (pushin) begin
                dout[0][3][63:40] <= #1 din[23:0];
                dout[1][3][63:0]  <= #1 din[87:24];
                dout[2][3][63:0]  <= #1 din[151:88];
                dout[3][3][47:0]  <= #1 din[199:152];
            end
        end
        3'b110 : begin
            if (pushin) begin
                dout[3][3][63:48] <= #1 din[15:0];
                dout[4][3][63:0]  <= #1 din[79:16];
                dout[0][4][63:0]  <= #1 din[143:80];
                dout[1][4][55:0]  <= #1 din[199:144];
            end
        end
        3'b111 : begin
            if (pushin) begin
                dout[1][4][63:56] <= #1 din[7:0];
                dout[2][4][63:0]  <= #1 din[71:8];
                dout[3][4][63:0]  <= #1 din[135:72];
                dout[4][4][63:0]  <= #1 din[199:136];
            end
        end
    endcase
  end
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

wire [4:0][4:0][63:0]   muxrec;  //multiplexer line for recirculation
wire [4:0][4:0][63:0]   datain0, datain1, datain2, datain3;  //for input layers
wire [4:0][4:0][63:0]   datare0, datare1, datare2, datare3;  //for recirculate layers

/*======== REGISTER UPDATE ========*/
reg [1:0]               state, nextstate;
reg [4:0][4:0][63:0]    recirculate;
reg [6:0]               ringcounter;
integer i;
always @ (posedge clk or posedge reset) begin
  if(reset == 1) begin
    state <= `restart ;
    recirculate <= 1600'b0;
    datatag <= 32'b0;
    ringcounter <= 7'b0000_001;
  end else begin
    state <= #1 nextstate;
    recirculate <= #1 muxrec;
    if (state == `firstpush) begin
        datatag[31:28] <= #1 din[4][4][63:60];
        datatag[27:24] <= #1 din[1][4][55:52];
        datatag[23:20] <= #1 din[3][3][47:44];
        datatag[19:16] <= #1 din[0][3][39:36];
        datatag[15:12] <= #1 din[2][2][31:28];
        datatag[11:8] <=  #1 din[4][1][23:20];
        datatag[7:4] <=   #1 din[1][1][15:12];
        datatag[3:0] <=   #1 din[3][0][7:4];
    end
    if (state == `full) begin
        ringcounter[0] <= #1 ringcounter[6];
        ringcounter[1] <= #1 ringcounter[0];
        ringcounter[2] <= #1 ringcounter[1];
        ringcounter[3] <= #1 ringcounter[2];
        ringcounter[4] <= #1 ringcounter[3];
        ringcounter[5] <= #1 ringcounter[4];
        ringcounter[6] <= #1 ringcounter[5];
    end
  end
end
/*==== END REGISTER UPDATE ====*/

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
wire [4:0] inround1, inround2, inround3;
assign inround1 = 5'd0;
assign inround2 = 5'd1;
assign inround3 = 5'd2;
always @ (*) begin
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
/*==== END ROUND SETTER ====*/

/*======== DATAPATH ========*/
assign pushout = ringcounter[6];
assign datain0 = din;
assign datare0 = recirculate;
//input layers
permLayer layer_inone2 (datain0, inround1, datain1);
permLayer layer_intwo2 (datain1, inround2, datain2);
permLayer layer_inthr2 (datain2, inround3, datain3);
//recirculate layers
permLayer layer_reone2 (datare0, round1, datare1);
permLayer layer_retwo2 (datare1, round2, datare2);
permLayer layer_rethr2 (datare2, round3, datare3);
//output and mux recirculation
assign muxrec = (state == `firstpush) ? (datain3) : (datare3);
assign dout = datare3;
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
  // For all pairs (x, z) such that 0 d x < 5 and 0 d z < w, let
  // C[x, z] = A[x, 0, z]  A[x, 1, z]  A[x, 2, z]  A[x, 3, z]  A[x, 4, z].
  for(x=0; x<5 ; x=x+1)
  begin
    for(z=0 ; z<64 ; z=z+1)
    begin
      C[x][z] = theta_in[x][0][z] ^ theta_in[x][1][z] ^ theta_in[x][2][z] ^ theta_in[x][3][z] ^ theta_in[x][4][z];
    end 
  end 

  // STEP : 2
  //For all pairs (x, z) such that 0 d x < 5 and 0 d z < w let
  //D[x, z] = C[(x-1) mod 5, z]  C[(x+1) mod 5, (z  1) mod w].
  for(x=0; x<5 ; x=x+1)
  begin
    for(z=0 ; z<64 ; z=z+1)
    begin
      D[x][z] = C[modulo_operation_5(x-1,5)][z] ^ C[modulo_operation_5(x+1,5)] [modulo_operation_5(z-1,64)];
    end 
  end 

  // STEP : 3
  //For all triples (x, y, z) such that 0 d x < 5, 0 d y < 5, and 0 d z < w, let
  //A2[x, y, z] = A[x, y, z]  D[x, z].

  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      //for(z=0 ; z<64 ; z=z+1)
      //begin
        theta_out[x][y]/*[z]*/ = theta_in[x][y]/*[z]*/ ^ D[x]/*[z]*/;
      //end 
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

//Steps:
//1. For all z such that 0 d z < w, let A2 [0, 0, z] = A[0, 0, z]
//2. Let (x, y) = (1, 0).
//13
//3. For t from 0 to 23:
//a. for all z such that 0 d z < w, let A2[x, y, z] = A[x, y, (z  (t + 1)(t + 2)/2) mod w];
//b. let (x, y) = (y, (2x + 3y) mod 5).
//4. Return A2

always @(*)
begin
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
//1. For all triples (x, y, z) such that 0 d x < 5, 0 d y < 5, and 0 d z < w, let
//A2[x, y, z]= A[(x + 3y) mod 5, x, z].
//2. Return A2.

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
//1. For all triples (x, y, z) such that 0 d x < 5, 0 d y < 5, and 0 d z < w, let
//A2 [x, y, z] = A[x, y, z]  ((A[(x+1) mod 5, y, z]  1) Å A[(x+2) mod 5, y, z]).
//2. Return A2.

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        chi_out[x][y][z] = chi_in[x][y][z] ^ (~chi_in[modulo_operation_5_1(x+1,5)][y][z] * chi_in[modulo_operation_5_1((x+2),5)][y][z]);
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
reg [4:0][4:0][63:0]   dout;

reg [63:0] rc;

always @ (roundin) begin
    case (roundin)
        5'd0  : rc = 64'h0000000000000001;
        5'd1  : rc = 64'h0000000000008082;
        5'd2  : rc = 64'h800000000000808A;
        5'd3  : rc = 64'h8000000080008000;
        5'd4  : rc = 64'h000000000000808B;
        5'd5  : rc = 64'h0000000080000001;
        5'd6  : rc = 64'h8000000080008081;
        5'd7  : rc = 64'h8000000000008009;
        5'd8  : rc = 64'h000000000000008A;
        5'd9  : rc = 64'h0000000000000088;
        5'd10 : rc = 64'h0000000080008009;
        5'd11 : rc = 64'h000000008000000A;
        5'd12 : rc = 64'h000000008000808B;
        5'd13 : rc = 64'h800000000000008B;
        5'd14 : rc = 64'h8000000000008089;
        5'd15 : rc = 64'h8000000000008003;
        5'd16 : rc = 64'h8000000000008002;
        5'd17 : rc = 64'h8000000000000080;
        5'd18 : rc = 64'h000000000000800A;
        5'd19 : rc = 64'h800000008000000A;
        5'd20 : rc = 64'h8000000080008081;
        5'd21 : rc = 64'h8000000000008080;
        5'd22 : rc = 64'h0000000080000001;
        5'd23 : rc = 64'h8000000080008008;
        default : rc = 64'h0;
    endcase
end

//modify lane x=0,y=0 by rc
integer x, y, z;
always @ (*) begin
    for (x=0;x<5;x=x+1) begin
        for (y=0;y<5;y=y+1) begin
            for (z=0;z<64;z=z+1) begin
                if ((x==0) && (y==0)) begin
                    dout[x][y][z] = din[x][y][z] ^ rc[z];
                end
                else begin
                    dout[x][y][z] = din[x][y][z];
                end
            end
        end
    end
end

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

/* ======== REGISTER UPDATE ======== */
always @ (posedge clk or posedge reset) begin
   if(reset==1)begin
    doutix <= 3'd0;
    state <= `restart ;
    outreg <= 1600'b0;
    datatag <= 32'b0;
   end else begin
    state <= #1 nextstate;

    if (pushin) begin
        outreg[319:0]     <= #1 {din[4][0][63:0], din[3][0][63:0], din[2][0][63:0], din[1][0][63:0], din[0][0][63:0]};
        outreg[639:320]   <= #1 {din[4][1][63:0], din[3][1][63:0], din[2][1][63:0], din[1][1][63:0], din[0][1][63:0]};
        outreg[959:640]   <= #1 {din[4][2][63:0], din[3][2][63:0], din[2][2][63:0], din[1][2][63:0], din[0][2][63:0]};
        outreg[1279:960]  <= #1 {din[4][3][63:0], din[3][3][63:0], din[2][3][63:0], din[1][3][63:0], din[0][3][63:0]};
        outreg[1599:1280] <= #1 {din[4][4][63:0], din[3][4][63:0], din[2][4][63:0], din[1][4][63:0], din[0][4][63:0]};
        datatag <= #1 intag;
    end

    if ((state == `yespush) || (state == `pbranch)) begin
        doutix <= #1 nextix;
    end
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

always @(*) begin
  #1;
  $display("o %d %h",doutix,dout);
end 

endmodule
/*============ END OUTPUT_INTERFACE ============*/





