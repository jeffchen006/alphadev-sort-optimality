# n=5 model=out iset=I1 prefix14_class=14465
cmp P2, P0
cmovge S1, P2
mov S2, P1
cmovg P2, P0
cmovg P0, S1
cmp P1, P3
cmovl S2, P3
cmovge P1, P3
cmp P1, P2
mov S0, P1
cmovle S0, P2
cmovl P2, P1
cmp S2, P0
cmovl P3, S2
