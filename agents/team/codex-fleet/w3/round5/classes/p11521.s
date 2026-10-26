# n=5 model=out iset=I1 prefix14_class=11521
mov S0, P0
cmp P3, P0
mov S1, P1
cmovge S0, P3
cmovle P0, P3
cmp P2, S1
cmovl P1, P2
mov P3, S0
cmovl P2, S1
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovle P1, S1
mov S2, P0
