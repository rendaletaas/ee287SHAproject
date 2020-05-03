//Ensure you are in the right shell (>source /apps/design_environment.csh)
rm -rf simv*
vcs +v2k -sverilog verif_tb_ver2.sv perm.sv -l compile.log
./simv -l run.log
