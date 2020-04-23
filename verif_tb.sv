module testbench();

reg[4:0][4:0][63:0] A,A1,A2,A3;
wire[4:0][4:0][63:0] dout;
wire[4:0][4:0][63:0] dout1;
wire[4:0][4:0][63:0] dout2;
wire[4:0][4:0][63:0] dout3;
reg [199:0]String[0:7];
reg [1599:0]S;

theta t1 (.theta_in(A),.theta_out(dout));
rho   r1 (.rho_in(A1),.rho_out(dout1));
pi    p1 (.pi_in(A2),.pi_out(dout2));
chi   c1 (.chi_in(A3),.chi_out(dout3));


initial begin
end 

integer x,y,z;

parameter X=5;
parameter Y=5;
parameter Z=64;

always @(*) begin
    for(x=0;x<X;x=x+1)begin
        for(y=0;y<Y;y=y+1)begin
            for(z=0;z<Z;z=z+1)begin
                A[x][y][z] = S[Z*(Y*y+x)+z];
            end
        end
    end
end


initial begin
    String[0] = 200'h60a636261;
	String[1] = 200'b0;
	String[2] = 200'b0;
	String[3] = 200'b0;
	String[4] = 200'b0;
	String[5] = 200'h8000000000000000000000;
	String[6] = 200'b0;
	String[7] = 200'b0;
end

initial begin
    S = 0;
    #10;
	S = {String[7],String[6],String[5],String[4],String[3],String[2],String[1],String[0]};
    #10;
    S = 0;
    display(dout,"theta","0");
    for(x=0;x<X;x=x+1)begin
        for(y=0;y<Y;y=y+1)begin
            for(z=0;z<Z;z=z+1)begin
                A1[x][y][z] = dout[x][y][z];
            end
        end
    end
    #100;    
    display(dout1,"rho","0");
    for(x=0;x<X;x=x+1)begin
        for(y=0;y<Y;y=y+1)begin
            for(z=0;z<Z;z=z+1)begin
                A2[x][y][z] = dout1[x][y][z];
            end
        end
    end
#100;
    display(dout2,"pi","0");
    for(x=0;x<X;x=x+1)begin
        for(y=0;y<Y;y=y+1)begin
            for(z=0;z<Z;z=z+1)begin
                A3[x][y][z] = dout2[x][y][z];
            end
        end
    end
#20;
    display(dout3,"chi","0");
    $finish;          
end                   
                      
initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
end


endmodule 
