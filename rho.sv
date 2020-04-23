module rho(rho_in,rho_out);

input reg [4:0][4:0][63:0] rho_in;
output reg [4:0][4:0][63:0] rho_out;

reg [8:0] offset[4:0][4:0] ;

integer x,y,z;

initial begin
  offset[0][0] = 9'd0; 
  offset[0][1] = 9'd36; 
  offset[0][2] = 9'd3;
  offset[0][3] = 9'd105;
  offset[0][4] = 9'd210;
  offset[1][0] = 9'd1; 
  offset[1][1] = 9'd300; 
  offset[1][2] = 9'd10; 
  offset[1][3] = 9'd45; 
  offset[1][4] = 9'd66; 
  offset[2][0] = 9'd190; 
  offset[2][1] = 9'd6; 
  offset[2][2] = 9'd171; 
  offset[2][3] = 9'd15; 
  offset[2][4] = 9'd253; 
  offset[3][0] = 9'd28; 
  offset[3][1] = 9'd55; 
  offset[3][2] = 9'd153; 
  offset[3][3] = 9'd21; 
  offset[3][4] = 9'd120; 
  offset[4][0] = 9'd91; 
  offset[4][1] = 9'd276; 
  offset[4][2] = 9'd231; 
  offset[4][3] = 9'd136; 
  offset[4][4] = 9'd78; 
end

//Steps:
//1. For all z such that 0 ≤ z < w, let A′ [0, 0, z] = A[0, 0, z]
//2. Let (x, y) = (1, 0).
//13
//3. For t from 0 to 23:
//a. for all z such that 0 ≤ z < w, let A′[x, y, z] = A[x, y, (z – (t + 1)(t + 2)/2) mod w];
//b. let (x, y) = (y, (2x + 3y) mod 5).
//4. Return A′

always @(*)
begin
  for(x=0; x<5 ; x=x+1)
  begin
    for(y=0 ; y<5 ; y=y+1)
    begin
      for(z=0 ; z<64 ; z=z+1)
      begin
        rho_out[x][y][z] = rho_in[x][y][modulo_operation_64((z-offset[x][y]),64)];
      end 
    end
  end 
end 

function integer modulo_operation_64(input integer value,input integer modulo_value);

integer shifted_value;
integer result_value;

begin
end 

if(value == modulo_value) 
begin
  result_value = value;
end 
else 
begin
  shifted_value = value >> 6;
  shifted_value = shifted_value << 6;
  result_value  = value - shifted_value;
end
  modulo_operation_64 = result_value;
endfunction : modulo_operation_64 


endmodule 
