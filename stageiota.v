module stageiota (iround, din, dout);
    input [4:0] iround;
    input din [4:0][4:0][63:0];
    output dout [4:0][4:0][63:0];
    
    genvar x0, y0, z0;
    generate
        for (x0=0; x0<5; x0=x0+1) begin
            for (y0=0; y0<5; y0=y0+1) begin
                if ((x0==0) && (y0==0)) begin
                    //no assignment
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
