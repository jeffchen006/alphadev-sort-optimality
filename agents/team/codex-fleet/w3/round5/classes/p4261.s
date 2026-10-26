# n=5 model=out iset=I1 prefix14_class=4261
mov S0, P2
mov S1, P3
cmp P0, P3
cmovge S1, P0
cmovl P3, P0
cmp P1, P2
cmovge P2, P1
cmovg P1, S0
cmp P3, P1
mov S2, P1
cmovle P1, P3
cmovge S2, P3
mov P3, S2
cmp P2, S1
