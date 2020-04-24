module stageiota (din, inR, dout, outR);
    input din [4:0][4:0][63:0];
    input [4:0] inRound;
    output dout [4:0][4:0][63:0];
    output [8:0] outR;
    
    wire din [4:0][4:0][63:0];
    wire [4:0] inRound;
    wire dout [4:0][4:0][63:0];
    wire [8:0] outR;
    
    reg [63:0] rc;

    always @ (inRound) begin
        case (inRound)
            5'd0  : rc <= 64'h0000000000000001;
            5'd1  : rc <= 64'h0000000000008082;
            5'd2  : rc <= 64'h800000000000808A
            5'd3  : rc <= 64'h8000000080008000
            5'd4  : rc <= 64'h000000000000808B
            5'd5  : rc <= 64'h0000000080000001
            5'd6  : rc <= 64'h8000000080008081
            5'd7  : rc <= 64'h8000000000008009
            5'd8  : rc <= 64'h000000000000008A
            5'd9  : rc <= 64'h0000000000000088
            5'd10 : rc <= 64'h0000000080008009
            5'd11 : rc <= 64'h000000008000000A
            5'd12 : rc <= 64'h000000008000808B
            5'd13 : rc <= 64'h800000000000008B
            5'd14 : rc <= 64'h8000000000008089
            5'd15 : rc <= 64'h8000000000008003
            5'd16 : rc <= 64'h8000000000008002
            5'd17 : rc <= 64'h8000000000000080
            5'd18 : rc <= 64'h000000000000800A
            5'd19 : rc <= 64'h800000008000000A
            5'd20 : rc <= 64'h8000000080008081
            5'd21 : rc <= 64'h8000000000008080
            5'd22 : rc <= 64'h0000000080000001
            5'd23 : rc <= 64'h8000000080008008
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
