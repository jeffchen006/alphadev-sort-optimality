# n=5 model=out iset=I1 prefix14_class=5290
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovg P0, P1
mov S1, P2
cmp P2, P3
cmovl S1, P3
mov S2, P0
cmovge P2, P3
cmp S2, P2
cmovge S2, P2
cmovl P0, P2
cmp S1, S0
cmovge P2, S0
