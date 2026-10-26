# n=5 model=out iset=I1 prefix14_class=10430
cmp P3, P2
mov S1, P2
cmovge S1, P3
cmovl P2, P3
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovl P0, S0
cmp P0, S1
cmovle P3, P0
mov S2, P1
cmovle P0, S1
cmovle S1, P3
cmp P2, P1
