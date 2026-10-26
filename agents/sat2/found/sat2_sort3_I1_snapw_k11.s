# n=3 R=14 iset=I1 model=out source=sat2_cnf_cegis k=11
cmp P0, P1
cmovge S0, P1
cmovle S0, P0
cmovl P0, P1
cmp P2, S0
cmovge S1, P2
cmovge P2, S0
cmovge S0, S1
cmp P0, S0
cmovge S1, P0
cmovge P0, S0
out 0, P2
out 1, P0
out 2, S1
