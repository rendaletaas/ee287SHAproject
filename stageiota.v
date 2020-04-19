module stageiota (din, inR, dout, outR);
    input din [4:0][4:0][63:0];
    input [7:0] inR;
    output dout [4:0][4:0][63:0];
    output [7:0] outR;
    
    wire din [4:0][4:0][63:0];
    wire [7:0] inR;
    wire dout [4:0][4:0][63:0];
    wire [7:0] outR;
    
    wire [8:0] tR0 [6:0];
    wire [7:0] tR1 [6:0];
    wire rc [63:0];
    wire rcmod;
    
    genvar a0;
    generate
        for (a0=0; a0<7; a0=a0+1) begin
            assign tR0[a0] = {1'b0, inR);
        end
    endgenerate
    
    genvar b0;
    generate
        for (b0=0; b0<7; b0=b0+1) begin
            assign tR1[b0] = {tR0[8]^tR0[0], tR0[7], tR0[6], tR0[5], tR0[4]^tR0[0], tR0[3]^tR0[0], tR0[2]^tR0[0], tR0[1]};
        end
    endgenerate

    assign outR = tR1[6];
    assign rcmod = outR[7];
    
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
