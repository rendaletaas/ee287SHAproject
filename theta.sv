module theta(theta_in,theta_out);

input reg [4:0][4:0][63:0] theta_in;
output reg [4:0] [4:0] [63:0] theta_out;

reg [4:0][63:0] C,D;

integer x,y,z;

always @(*)
begin
  // STEP : 1
  // For all pairs (x, z) such that 0 ≤ x < 5 and 0 ≤ z < w, let
  // C[x, z] = A[x, 0, z] ⊕ A[x, 1, z] ⊕ A[x, 2, z] ⊕ A[x, 3, z] ⊕ A[x, 4, z].

  // STEP : 2
  //For all pairs (x, z) such that 0 ≤ x < 5 and 0 ≤ z < w let
  //D[x, z] = C[(x-1) mod 5, z] ⊕ C[(x+1) mod 5, (z – 1) mod w].
  for(x=0; x<5 ; x=x+1)
  begin
    for(z=0 ; z<64 ; z=z+1)
    begin
      C[x][z] = theta_in[x][0][z] ^ theta_in[x][1][z] ^ theta_in[x][2][z] ^ theta_in[x][3][z] ^ theta_in[x][4][z];
      D[x][z] = C[modulo_operation_5(x-1,5)][z] ^ C[modulo_operation_5(x+1,5)] [modulo_operation_5(z-1,64)];
    end 
  end 

  // STEP : 3
  //For all triples (x, y, z) such that 0 ≤ x < 5, 0 ≤ y < 5, and 0 ≤ z < w, let
  //A′[x, y, z] = A[x, y, z] ⊕ D[x, z].

  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        theta_out[x][y][z] = theta_in[x][y][z] ^ D[x][z];
      end 
    end
  end 
end 

function integer modulo_operation_5(input integer value,input integer modulo_value);

if (value == modulo_value)
begin
  modulo_operation_5 = 0;
end
else if (value < 0)
begin
  modulo_operation_5 = modulo_value + value;
end
else begin
  modulo_operation_5 = value;
end 

endfunction : modulo_operation_5 

endmodule : theta
