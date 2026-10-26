# n=5 model=out iset=I1 prefix14_class=3660
mov S0, P0
cmp P1, P3
mov S1, P1
cmovle P1, P3
cmovl P3, S1
cmovge S1, P3
cmp P2, S0
cmovle P0, P2
cmovl P2, S0
cmp P0, P3
cmovle S1, P0
cmovg P3, P0
cmp P2, P1
cmovge S2, P1
