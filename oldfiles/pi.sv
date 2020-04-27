module pi(pi_in,pi_out);

input reg [4:0][4:0][63:0] pi_in;
output reg [4:0][4:0][63:0] pi_out;

integer x,y,z;

//Steps:
//1. For all triples (x, y, z) such that 0 ≤ x < 5, 0 ≤ y < 5, and 0 ≤ z < w, let
//A′[x, y, z]= A[(x + 3y) mod 5, x, z].
//2. Return A′.

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        pi_out[x][y][z] = pi_in[modulo_operation_5_1((x+3*y),5)][x][z];
      end 
    end
  end 
end 

function integer modulo_operation_5_1(input integer value,input integer modulo_value);

if (value == modulo_value)
begin
  modulo_operation_5_1 = 0;
end
else if(value >=0 && value <5) begin
  modulo_operation_5_1 = value;
end 
else if(value >= 5 && value <10)begin
  modulo_operation_5_1 = value - 5;
end 
else if(value >= 10 && value <15)begin
  modulo_operation_5_1 = value - 10;
end 
else if(value >= 15 && value <20)begin
  modulo_operation_5_1 = value - 15;
end 
else if(value >= 20 && value <25)begin
  modulo_operation_5_1 = value - 20;
end else 
begin
  modulo_operation_5_1 = value -25;
end 


endfunction : modulo_operation_5_1 

endmodule 
