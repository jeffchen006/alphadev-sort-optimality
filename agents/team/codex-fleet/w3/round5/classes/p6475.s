# n=5 model=out iset=I1 prefix14_class=6475
mov S0, P3
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P2, S0
cmovle P3, P2
cmovge S0, P2
cmp P0, S0
cmovle S2, P0
cmovl P0, S0
cmovge S2, S0
cmp P3, P1
mov P2, P1
