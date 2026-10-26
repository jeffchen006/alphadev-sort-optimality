# n=5 model=out iset=I1 prefix14_class=13330
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P2, P0
mov S2, P3
mov S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P0, P3
cmovle P3, P0
cmovge S2, P0
cmp P1, P2
cmovge P3, P2
