//LEVEL 0: PERM
//    LEVEL 1: INPUTINTERFACE
//    LEVEL 1: PERMLOGIC
//        LEVEL 2: THETA
//        LEVEL 2: RHO
//        LEVEL 2: PI
//        LEVEL 2: CHI
//        LEVEL 2: IOTA
//    LEVEL 1: OUTPUTINTERFACE

`define empty 2'b00
`define firstpush 2'b01
`define full 2'b11
`define restart 2'b10

/*============ LEVEL 0: PERM ============*/
module perm(clk, reset, dix, din, pushin, doutix, dout, pushout);
    input          clk, reset, pushin;
    input  [2:0]   dix;
    input  [199:0] din;
    output [2:0]   doutix;
    output [199:0] dout;
    output         pushout;
    
    wire          clk, reset, pushin, pushout, push0;
    wire [199:0]  din, dout;
    wire data0 [4:0][4:0][63:0];
    wire data1 [4:0][4:0][63:0];
    wire [2:0]    dix, dout;
    wire [7:0]    tag;
    
    inputInterface  block0 (.din(din), .dix(dix), .pushin(pushin), .clk(clk), .reset(reset), .dout(data0));
    permLogic       block1 (.din(data0), .dix(dix), .pushin(pushin), .clk(clk), .reset(reset), .dout(data1), .tagout(tag), .pushout(push0));
    outputInterface block2 (.din(data1), .pushin(push0), .clk(clk), .reset(reset), .dout(dout), .tagin(tag), .pushout(pushout), .doutix(doutix);
endmodule : perm

/*============ LEVEL 1: INPUTINTERFACE ============*/
module inputInterface(clk, reset, dix, din, pushin, dout);
    input           clk, reset, pushin;
    input  [2:0]    dix;
    input  [199:0]  din;
    output dout [4:0][4:0][63:0];
    
    wire          clk, reset, pushin;
    wire [2:0]    dix;
    wire [199:0]  din;
    reg  dout [4:0][4:0][63:0];
    
    integer ireset [2:0];
    
    always @ (posedge reset) begin
        for (ireset[2]=0; ireset[2]<5; ireset[2]=ireset[2]+1) begin
            for (ireset[1]=0; ireset[1]<5; ireset[1]=ireset[1]+1) begin
                for (ireset[0]=0; ireset[0]<63; ireset[0]=ireset[0]+1) begin
                    dout[ireset[2]][ireset[1]][ireset[0]] <= 0;
                end
            end
        end
    end
    
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
                    dout[4][4][63:0]  <= din[199:144];
                end
            end
        endcase
    end
endmodule : inputInterface

/*============ LEVEL 1: PERMLOGIC ============*/
module permLogic(clk, reset, dix, din, pushin, dout, tagout, pushout);
    input           clk, reset, pushin;
    input  [2:0]    dix;
    input  din [4:0][4:0][63:0];
    output dout [4:0][4:0][63:0];
    output [7:0]    tagout;
    output          pushout;
    
    wire          clk, reset, pushin;
    wire [2:0]    dix;
    wire din [4:0][4:0][63:0];
    wire dout [4:0][4:0][63:0];
    wire data0 [4:0][4:0][63:0];  //datapath connections between permutation layers
    wire data1 [4:0][4:0][63:0];
    wire data2 [4:0][4:0][63:0];
    wire          pushout;
    wire          stateA;  //controller connection A on block diagram
    reg  [7:0]    tagout;
    reg  recirculate [4:0][4:0][63:0];
    reg  [1:0]    state;
    reg  [1:0]    nextstate;
    reg  [5:0]    ringcounter;
    
    /* ======== CONTROLLER LOGIC ======== */
    assign stateA = &dix && pushin;
    always @ (state) begin
        case (state)
            `empty : begin
                if (stateA)
                    nextstate = `firstpush;
                else
                    nextstate = `empty;
            end
            `firstpush : begin
                nextstate = `full;
            end
            `full : begin
                if (~ringcounter[5])
                    nextstate = `full;
                else begin
                    if (stateA)
                        nextstate = `firstpush;
                    else
                        nextstate = `empty;
                end
            end
            `restart : begin
                nextstate = `empty;
            end
        endcase
    end
    assign pushout = ringcounter[5];
    
    /* ======== REGISTER RESET ======== */
    always @ (posedge reset) begin
        tagout <= 8'b0;
        recirculate <= 1600'b0;
        state0 <= 1;
        state1 <= 0;
        ringcounter <= 6'b100000;
    end
    
    /* ======== REGISTER UPDATE ======== */
    always @ (posedge clk) begin
        if (state == `firstpush)
            tagout <= din[7:0];
        if ((state == `firstpush) || (state == `full))
            recirculate <= dout;
        state <= nextstate;
        if (state == `full) begin
            ringcounter[0] <= ringcounter[5];
            ringcounter[1] <= ringcounter[0];
            ringcounter[2] <= ringcounter[1];
            ringcounter[3] <= ringcounter[2];
            ringcounter[4] <= ringcounter[3];
            ringcounter[5] <= ringcounter[4];
        end
    end
    
    /* ======== DATAPATH ======== */
    assign data0 = (state == `firstpush) ? (din) : (recirculate);
    permLayer layer0 (.din(data0), .dout(data1));
    permLayer layer1 (.din(data1), .dout(data2));
    permLayer layer2 (.din(data2), .dout(dout));
endmodule

/*============ LEVEL 2: THETA ============*/
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

endmodule : theta

