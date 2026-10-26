# n=5 model=out iset=I1 prefix14_class=7625
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovl P2, P3
cmp P1, P0
mov P3, P1
cmovge P3, P0
cmovg P0, P1
cmp P2, P3
cmovl P1, P3
cmovl P3, P2
cmovl P2, P1
cmp P0, S2
cmovle P3, S2
