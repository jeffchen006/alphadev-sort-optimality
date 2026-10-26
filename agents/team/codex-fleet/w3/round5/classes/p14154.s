# n=5 model=out iset=I1 prefix14_class=14154
cmp P3, P2
mov S2, P1
cmovl S1, P2
cmovle P2, P3
cmovl P3, S1
cmp P0, S2
cmovg S2, P0
cmovg P0, P1
mov P1, P3
cmp P1, S2
cmovge P1, S2
cmovge S2, P3
cmp P0, P2
cmovl S0, P0
