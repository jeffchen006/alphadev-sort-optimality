# n=5 model=out iset=I1 prefix14_class=2587
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P0, P2
cmovge S1, P0
cmovl S1, P2
cmovge P0, P2
cmp S1, P1
cmovle S0, S1
cmovle S1, P1
cmovge S0, P1
cmp P3, P0
cmovg S2, P0
