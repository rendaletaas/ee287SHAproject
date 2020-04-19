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
                if (pushin)
                    dout[199:0] <= din;
            end
            3'b001 : begin
                if (pushin)
                    dout[399:200] <= din;
            end
            3'b010 : begin
                if (pushin)
                    dout[599:400] <= din;
            end
            3'b011 : begin
                if (pushin)
                    dout[799:600] <= din;
            end
            3'b100 : begin
                if (pushin)
                    dout[999:800] <= din;
            end
            3'b101 : begin
                if (pushin)
                    dout[1199:1000] <= din;
            end
            3'b110 : begin
                if (pushin)
                    dout[1399:1200] <= din;
            end
            3'b111 : begin
                if (pushin)
                    dout[1599:1400] <= din;
            end
        endcase
    end
endmodule
