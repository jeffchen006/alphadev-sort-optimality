# n=5 model=out iset=I1 prefix14_class=5537
cmp P0, P1
mov S2, P1
cmovle S2, P0
mov S1, P2
cmovl P0, P1
cmovl P1, S2
cmp S1, P3
cmovl S1, P3
cmovge P2, P3
cmp S2, P2
cmovl P1, P2
cmovge S2, P2
cmp P0, S1
cmovg P2, P1
