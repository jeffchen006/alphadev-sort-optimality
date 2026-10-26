# n=5 model=out iset=I1 prefix14_class=14358
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmovle S1, P2
cmp P0, P3
cmovle P2, P0
mov S0, P1
cmovle P0, P3
mov S2, S1
cmovl P3, P2
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp P0, S2
