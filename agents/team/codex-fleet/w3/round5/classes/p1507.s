# n=5 model=out iset=I1 prefix14_class=1507
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovge P2, P3
cmp P0, P1
cmovle S2, P0
cmovge S2, P1
cmovg P1, P0
cmp S0, S2
cmovge P0, S0
cmovge S0, S2
cmovg S2, P0
cmp P2, P1
cmovle S1, P2
