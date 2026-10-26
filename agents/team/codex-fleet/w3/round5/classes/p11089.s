# n=5 model=out iset=I1 prefix14_class=11089
mov S0, P2
cmp P1, S0
cmovle P2, P1
cmovge S0, P1
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P3, S0
cmovle S2, S0
cmovle S0, P3
cmovl P3, S2
cmp P0, P2
cmovle P1, P2
