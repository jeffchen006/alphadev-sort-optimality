# n=5 model=out iset=I1 prefix14_class=5129
cmp P0, P2
mov S1, P0
mov S2, P3
cmovle S1, P2
cmovle P2, P0
cmp P1, S2
cmovle S2, P1
mov S0, S2
cmovl P1, P3
cmp P2, S0
cmovge S0, P2
cmovle S2, P2
cmp P1, S1
cmovg P3, S1
