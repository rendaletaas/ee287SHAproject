function display;
    input [1599:0]S;
    input string algo;
    input string round;
    parameter Z = 64;
    $display("# after %s %s #",algo,round);
    $display("# %h %h %h %h %h",S[Z-1:0]     ,S[6*Z-1:5*Z]  ,S[11*Z-1:10*Z] ,S[16*Z-1:15*Z] ,S[21*Z-1:20*Z]); 
    $display("# %h %h %h %h %h",S[2*Z-1:Z]   ,S[7*Z-1:6*Z]  ,S[12*Z-1:11*Z] ,S[17*Z-1:16*Z] ,S[22*Z-1:21*Z]); 
    $display("# %h %h %h %h %h",S[3*Z-1:2*Z] ,S[8*Z-1:7*Z]  ,S[13*Z-1:12*Z] ,S[18*Z-1:17*Z] ,S[23*Z-1:22*Z]); 
    $display("# %h %h %h %h %h",S[4*Z-1:3*Z] ,S[9*Z-1:8*Z]  ,S[14*Z-1:13*Z] ,S[19*Z-1:18*Z] ,S[24*Z-1:23*Z]); 
    $display("# %h %h %h %h %h",S[5*Z-1:4*Z] ,S[10*Z-1:9*Z] ,S[15*Z-1:14*Z] ,S[20*Z-1:19*Z] ,S[25*Z-1:24*Z]);
endfunction

function full_display;
    input [1599:0] S0,S1,S2,S3,S4;
    input string round;

    display(S0,"theta"  ,round);
    display(S1,"rho"    ,round);
    display(S2,"rho-pi" ,round);
    display(S3,"chi"    ,round);
    display(S4,"end"    ,round);
endfunction
