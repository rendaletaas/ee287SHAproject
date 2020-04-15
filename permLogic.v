`define empty 2'b00
`define firstpush 2'b01
`define full 2'b11
`define restart 2'b10

module permLogic(clk, reset, dix, din, pushin, dout, tagout, pushout)
    input           clk, reset, pushin;
    input  [2:0]    dix;
    input  [1599:0] din;
    output [1599:0] dout;
    output [7:0]    tagout;
    output          pushout;
    
    wire          clk, reset, pushin;
    wire [2:0]    dix;
    wire [1599:0] din, dout;
    wire [1599:0] data0, data1, data2;  //datapath connections between permuation layers
    wire          pushout;
    wire          stateA;  //controller connection A on block diagram
    reg  [7:0]    tagout;
    reg  [1599:0] recirculate;
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
                    nextstate = empty;
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
                nextstate = empty;
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
