# n=5 model=out iset=I1 prefix14_class=12353
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovl P0, S1
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovge S2, P1
cmp P0, S2
cmovle S0, P0
cmovle P0, S2
cmovle S2, S0
cmp P2, P3
cmovle S2, P2
