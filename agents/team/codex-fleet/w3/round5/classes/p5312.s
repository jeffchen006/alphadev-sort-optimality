# n=5 model=out iset=I1 prefix14_class=5312
cmp P0, P2
mov S2, P0
cmovge S2, P2
cmovg P2, P0
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovle S1, P3
cmp P1, S2
cmovge S0, P1
cmovl S0, S2
cmovl S2, P1
cmp S1, P2
cmovge S2, S1
