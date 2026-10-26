# n=2 R=9 iset=I0 model=out source=sat2_cnf_cegis k=7 K=7
mov S0, P0
mov S1, P1
cmp P1, S0
mov P1, S1
cmovg S0, S1
out 1, S0
mov S0, P1
cmovl P0, S0
out 0, P0
