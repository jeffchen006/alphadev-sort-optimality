# n=5 model=out iset=I1 prefix14_class=1692
cmp P0, P2
mov S1, P3
cmovge S2, P0
cmovle S2, P2
cmovl P2, P0
cmp P1, S1
cmovl P3, P1
cmovle P1, S1
cmovle S1, P3
cmp P2, P3
cmovge P3, P2
cmovl S1, P2
cmp S2, P1
mov S1, P1
