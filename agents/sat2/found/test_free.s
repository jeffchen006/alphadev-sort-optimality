# n=2 R=6 iset=I0 model=out source=sat2_cnf_cegis k=4
cmp P1, P0
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
out 0, P0
out 1, P1
