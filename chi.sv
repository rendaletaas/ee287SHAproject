module chi(chi_in,chi_out);

input reg [4:0][4:0][63:0] chi_in;
output reg [4:0][4:0][63:0] chi_out;

integer x,y,z;


//Steps:
//1. For all triples (x, y, z) such that 0 ≤ x < 5, 0 ≤ y < 5, and 0 ≤ z < w, let
//A′ [x, y, z] = A[x, y, z] ⊕ ((A[(x+1) mod 5, y, z] ⊕ 1) ⋅ A[(x+2) mod 5, y, z]).
//2. Return A′.

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        chi_out[x][y][z] = chi_in[x][y][z] ^ ((chi_in[modulo_operation_5_1(x+1,5)][y][z]) ^ 1) * chi_in[modulo_operation_5_1((x+2),5)][y][z];
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
