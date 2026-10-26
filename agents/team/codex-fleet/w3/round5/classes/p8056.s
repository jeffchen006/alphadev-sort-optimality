# n=5 model=out iset=I1 prefix14_class=8056
mov S1, P0
mov S2, P1
cmp P3, S2
cmovle P1, P3
cmovl P3, S2
mov S0, P1
cmp P0, P2
cmovge S1, P2
cmovg P2, P0
cmp P1, S1
cmovle P1, S1
cmovge S0, S1
cmp P3, P2
cmovl P0, P2
