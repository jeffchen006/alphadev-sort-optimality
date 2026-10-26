# n=5 model=out iset=I1 prefix14_class=1527
cmp P3, P1
cmovge S0, P1
cmovl S0, P3
cmovg P1, P3
cmp P0, P2
cmovl S2, P0
cmovge S2, P2
cmovg P2, P0
cmp S0, S2
cmovge S1, S0
cmovge S0, S2
cmovg S2, S1
cmp P2, P1
cmovle P0, P2
