# n=5 model=out iset=I1 prefix14_class=14463
mov S0, P1
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovg P0, S2
cmp P1, P3
cmovle S0, P3
cmovg P1, P3
cmp P1, P2
mov S1, P1
cmovl S1, P2
cmovl P2, P1
cmp S0, P0
cmovge P3, P0
