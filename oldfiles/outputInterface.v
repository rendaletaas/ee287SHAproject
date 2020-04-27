module outputInterface(clk, reset, din, pushin, doutix, dout, pushout, tagin)
    input          clk, reset, pushin;
    input  din [4:0][4:0][63:0];
    input  [7:0]   tagin;
    output [2:0]   doutix;
    output [199:0] dout;
    output         pushout;
    
    wire          clk, reset, pushin;
    wire din [4:0][4:0][63:0];
    wire [7:0]    tagin;
    reg  [199:0]  dout;
    reg  [1599:0] outreg;
    reg  [2:0]    doutix, nextix;
    reg           pushout;
    reg  [7:0]    datatag;
    
    /* ======== REGISTER RESET ======== */
    always @ (posedge reset) begin
        outreg <= 1600'b0;
        doutix <= 3'b0;
        pushout <= 0;
        datatag <= 8'b0;
    end
    
    /* ======== REGISTER UPDATE ======== */
    always @ (posedge clk) begin
        if (pushin) begin
            outreg[319:0]     <= {din[4][0][63:0], din[3][0][63:0], din[2][0][63:0], din[1][0][63:0], din[0][0][63:0]};
            outreg[639:320]   <= {din[4][1][63:0], din[3][1][63:0], din[2][1][63:0], din[1][1][63:0], din[0][1][63:0]};
            outreg[959:640]   <= {din[4][2][63:0], din[3][2][63:0], din[2][2][63:0], din[1][2][63:0], din[0][2][63:0]};
            outreg[1279:960]  <= {din[4][3][63:0], din[3][3][63:0], din[2][3][63:0], din[1][3][63:0], din[0][3][63:0]};
            outreg[1599:1280] <= {din[4][4][63:0], din[3][4][63:0], din[2][4][63:0], din[1][4][63:0], din[0][4][63:0]};
        end
        pushout <= pushin || (doutix != 3'b111);
        doutix <= nextix;
    end
    
    /* ======== COUNTER UPDATE ======== */
    always @ (doutix or pushout) begin
        if (pushout) begin
            case (doutix)
                3'b000: nextix = 3'b001;
                3'b001: nextix = 3'b010;
                3'b010: nextix = 3'b011;
                3'b011: nextix = 3'b100;
                3'b100: nextix = 3'b101;
                3'b101: nextix = 3'b110;
                3'b110: nextix = 3'b111;
                3'b111: nextix = 3'b000;
            endcase
        end
    end
    
    /* ======== DATAPATH ======== */
    always @ (doutix or outreg) begin
        case (doutix)
            3'b000: dout = outreg[199:0];
            3'b001: dout = outreg[399:200];
            3'b010: dout = outreg[599:400];
            3'b011: dout = outreg[799:600];
            3'b100: dout = outreg[999:800];
            3'b101: dout = outreg[1199:1000];
            3'b110: dout = outreg[1399:1200];
            3'b111: dout = outreg[1599:1400];
        endcase
    end
endmodule
