# n=5 model=out iset=I1 prefix14_class=11853
cmp P3, P0
mov S0, P3
cmovl P3, P0
cmovge S0, P0
cmp P2, P1
cmovle P0, P2
cmovle P2, P1
cmovl P1, P0
cmp P3, P2
mov S2, S0
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
cmp P1, S0
