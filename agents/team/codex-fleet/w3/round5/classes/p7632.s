# n=5 model=out iset=I1 prefix14_class=7632
mov S0, P2
cmp P2, P3
cmovl P2, P3
cmovl P3, S0
cmp P1, P0
cmovle S0, P0
cmovge S0, P1
cmovl P0, P1
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
cmovl P3, S2
mov S1, S0
cmp P2, S1
