# n=5 model=out iset=I1 prefix14_class=2497
mov S1, P0
cmp P2, S1
cmovl P0, P2
mov S0, P1
cmovl P2, S1
cmp P3, P1
cmovge S0, P3
cmovge P3, P1
cmp S0, P2
cmovle S2, P2
cmovle P2, S0
cmovge S2, S0
cmp P0, P3
cmovge P1, P0
