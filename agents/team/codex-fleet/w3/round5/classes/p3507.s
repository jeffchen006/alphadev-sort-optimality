# n=5 model=out iset=I1 prefix14_class=3507
mov S2, P2
cmp P1, S2
mov S1, P3
cmovge S2, P1
cmovge P1, P2
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmp P1, S1
cmovl P2, P1
cmovle P1, S1
cmovl S1, P2
mov P3, S2
cmp P0, S2
