# n=5 model=out iset=I1 prefix14_class=7911
cmp P2, P3
cmovl S2, P2
cmovle P2, P3
cmovl P3, S2
mov S1, P1
cmp P0, P1
cmovl S1, P0
cmovge P1, P0
cmovge P0, S1
cmp P3, S1
cmovge S1, P3
cmovle P0, P3
cmp P1, P2
cmovg P0, P2
