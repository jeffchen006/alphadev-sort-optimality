# n=5 model=out iset=I1 prefix14_class=2470
cmp P3, P2
mov S1, P3
cmovge P3, P2
cmovl S1, P2
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
cmovg P0, S2
cmp S1, P1
cmovl P2, P1
cmovl P1, S1
cmovge P2, S1
cmp P0, P3
cmovle S2, P3
