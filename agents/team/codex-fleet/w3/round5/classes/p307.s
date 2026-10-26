# n=5 model=out iset=I1 prefix14_class=307
cmp P1, P0
mov S2, P3
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
cmp P2, S2
cmovl S2, P2
cmovg P3, P2
cmp P1, S2
mov P2, S2
cmovl P2, P1
cmovle P1, S2
cmp P0, P3
cmovl S1, P3
