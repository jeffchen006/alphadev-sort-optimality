# n=5 model=out iset=I1 prefix14_class=2207
cmp P3, P1
mov S2, P1
cmovge P1, P3
cmovge P3, S2
cmovge S2, P1
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovg P2, S0
cmp P1, P0
cmovle P1, P0
cmovl P0, S2
mov S1, P2
cmp P3, S1
