# n=5 model=out iset=I1 prefix14_class=7193
mov S1, P3
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmovge P1, S0
cmp S1, P0
cmovge S1, P0
cmovg P0, P3
mov S2, S1
cmp S2, P1
cmovl S1, P1
cmovge S2, P1
cmp P0, P2
cmovle S2, P0
