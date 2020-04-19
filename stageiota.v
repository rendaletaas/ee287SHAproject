module stageiota (din, inR, dout, outR);
    input din [4:0][4:0][63:0];
    input [8:0] inR;
    output dout [4:0][4:0][63:0];
    output [8:0] outR;
    
    wire din [4:0][4:0][63:0];
    wire [8:0] inR;
    wire dout [4:0][4:0][63:0];
    wire [8:0] outR;
    
    wire tR0 [6:0][8:0];
    wire rcmod [6:0];
    wire rc [63:0];

    //Evaluate the next 7 modification values rcmod
    genvar a0, b0;
    generate
        for(a0=0; a0<6; a0=a0+1) begin
            if (a0 == 0) begin
                for (b0=1; b0<9; b0=b0+1) begin
                    if (b0 == 8)
                        assign tR0[a0][b0] = 1'b0 ^ inR[1];
                    else if ((b0 == 4)||(b0 == 3)||(b0 == 2))
                        assign tR0[a0][b0] = inR[b0+1] ^ inR[1];
                    else
                        assign tR0[a0][b0] = inR[b0+1];
                end
            end
            else begin
                for (b0=1; b0<9; b0=b0+1) begin
                    if (b0 == 8)
                        assign tR0[a0][b0] = 1'b0 ^ tR0[a0-1][1];
                    else if ((b0 == 4)||(b0 == 3)||(b0 == 2))
                        assign tR0[a0][b0] = tR0[a0-1][b0+1] ^ tR0[a0-1][1];
                    else
                        assign tR0[a0][b0] = tR0[a0-1][b0+1];
                end
            end
            assign rcmod[a0] = ^tR0[a0][8:1];
        end
    endgenerate
    
    //place rcmod into the specific rc bits
    assign rc[0] = rcmod[0];
    assign rc[1] = rcmod[1];
    assign rc[3] = rcmod[2];
    assign rc[7] = rcmod[3];
    assign rc[15] = rcmod[4];
    assign rc[31] = rcmod[5];
    assign rc[63] = rcmod[6];
    
    //set the remaining bits of rc to 0
    genvar c0;
    generate
        for (c0=0; c0<64; c0=c0+1) begin
            if ((c0 != 0) || (c0 != 3) || (c0 != 7) || (c0 != 15) || (c0 != 31) || (c0 != 63))
                assign rc[c0] = 1'b0;                
        end
    endgenerate
    
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
