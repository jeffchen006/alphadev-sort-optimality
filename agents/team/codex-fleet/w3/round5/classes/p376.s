# n=5 model=out iset=I1 prefix14_class=376
mov S0, P0
mov S1, P2
cmp S0, P1
cmovl P0, P1
cmovge S0, P1
cmp P2, P3
cmovle S1, P3
mov P1, S0
cmovge P2, P3
cmp P2, P1
cmovl P1, P2
cmovl P2, S0
cmp P0, S1
cmovle S2, S1
