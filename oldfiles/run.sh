rm -rf simv*
vcs +v2k -sverilog theta.sv chi.sv rho.sv pi.sv verif_tb.sv display_fn.sv -l compile.log
./simv -l run.log
