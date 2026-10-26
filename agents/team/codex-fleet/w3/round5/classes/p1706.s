# n=5 model=out iset=I1 prefix14_class=1706
cmp P3, P1
cmovge S2, P3
cmovl S2, P1
cmovle P1, P3
cmp P2, P0
cmovle P3, P0
cmovle P0, P2
mov S1, P0
cmovl P2, P3
cmp P1, P0
cmovge P0, P1
cmovl S1, P1
cmp P2, S2
mov S1, S2
