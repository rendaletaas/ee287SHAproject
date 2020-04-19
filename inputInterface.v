module inputInterface(clk, reset, dix, din, pushin, dout)
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
endmodule
