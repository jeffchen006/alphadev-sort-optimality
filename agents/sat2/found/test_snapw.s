# n=2 R=6 iset=I0 model=out source=sat2_cnf_cegis k=4
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovl P1, S0
out 0, P0
out 1, P1
