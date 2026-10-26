# n=3 R=14 iset=I1 model=out source=sat2_cnf_cegis k=11 K=11
mov S0, P0
cmp P1, P2
cmovge S1, P1
cmovle S1, P2
cmovle P2, P1
cmp S0, P2
cmovg S0, P2
cmovg P2, P0
cmp P2, S1
cmovle P0, S1
cmovl S1, P2
out 0, S0
out 1, S1
out 2, P0
