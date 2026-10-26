# n=5 model=out iset=I1 prefix14_class=2702
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovle P1, P0
mov P0, P2
cmp P2, P3
cmovl P0, P3
cmovle P3, P2
mov S1, S0
cmp P0, S1
cmovle S1, P0
cmovl P0, S0
mov P0, S1
cmp P3, P1
