# n=5 model=out iset=I1 prefix14_class=13314
cmp P1, P3
cmovge S0, P1
cmovge P1, P3
cmovg P3, S0
cmp P2, P0
mov S1, P2
cmovl S1, P0
mov S2, P1
cmovle P0, P2
cmp P0, P1
cmovge S2, P0
cmovl P1, P0
mov P1, P3
cmp P3, S1
