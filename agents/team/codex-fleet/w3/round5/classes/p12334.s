# n=5 model=out iset=I1 prefix14_class=12334
cmp P2, P3
mov S0, P2
cmovge S0, P3
cmovl P2, P3
cmp P1, P0
cmovle S1, P0
cmovge S1, P1
cmovge P1, P0
cmp P1, S0
cmovle P0, S0
cmovle S0, P1
cmovl P1, P0
cmp P2, S1
cmovge P0, P2
