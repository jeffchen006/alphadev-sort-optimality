# n=5 model=out iset=I1 prefix14_class=638
cmp P2, P0
cmovle S1, P2
mov S2, P1
cmovge S1, P0
cmovle P2, P0
cmp P1, P3
cmovge P1, P3
cmovge P3, S2
cmovl S2, P3
cmp S2, P2
cmovl P3, P2
cmovle P2, S2
cmp P1, S1
cmovge P3, S1
