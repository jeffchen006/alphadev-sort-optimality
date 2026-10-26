# n=5 model=out iset=I1 prefix14_class=1651
mov S2, P2
cmp P1, S2
cmovge P2, P1
cmovg P1, S2
cmp P3, P0
cmovl S1, P0
cmovge S1, P3
cmovl P0, P3
mov P3, P1
cmp P3, P0
mov S0, P2
cmovle P3, P0
cmovl P0, P1
cmovle P1, P3
