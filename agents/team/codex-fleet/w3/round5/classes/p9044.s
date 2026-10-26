# n=5 model=out iset=I1 prefix14_class=9044
mov S2, P3
cmp P2, S2
cmovle P3, P2
cmovl P2, S2
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
cmovg P0, S0
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P3, P0
mov P2, P0
