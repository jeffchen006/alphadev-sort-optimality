# n=5 model=out iset=I1 prefix14_class=9626
cmp P3, P2
cmovl S1, P2
cmovge S1, P3
cmovge P3, P2
cmp P0, P1
cmovge S2, P0
mov S0, S1
cmovl S2, P1
cmovg P0, P1
cmp S1, S2
cmovge S0, S2
cmovle S1, S2
cmp P3, P0
cmovge S2, P3
