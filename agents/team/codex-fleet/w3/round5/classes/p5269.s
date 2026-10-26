# n=5 model=out iset=I1 prefix14_class=5269
cmp P3, P0
cmovle S1, P3
cmovge S1, P0
cmovg P0, P3
mov S2, P2
cmovge P3, S1
cmp P1, S2
cmovge S2, P1
cmovl P2, P1
cmp S1, P2
cmovge P3, P2
cmovl S1, P2
cmp S2, P0
cmovl P2, S1
