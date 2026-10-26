# n=5 model=out iset=I1 prefix14_class=11666
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
mov S0, P2
cmovl P0, S1
cmp P1, S0
cmovle P2, P1
cmovl P1, S0
mov S2, P1
cmp P1, P3
cmovle S2, P3
cmovge P1, P3
cmp P0, P2
cmovge S0, P2
