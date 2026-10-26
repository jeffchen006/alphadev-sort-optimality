# n=3 R=4 iset=I1 model=out source=sat2_cnf_cegis k=11
mov S0, P0
cmp P1, P0
cmovg P0, P1
cmovg P1, S0
mov S0, P2
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmp P0, P1
cmovl P0, P1
cmovge P2, P1
out 0, P2
out 1, P0
out 2, S0
