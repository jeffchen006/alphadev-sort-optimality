# n=5 model=out iset=I1 prefix14_class=5115
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
cmp P0, P3
mov S1, P0
cmovle S1, P3
mov S2, P1
cmovg P0, P3
cmp P0, P1
cmovl P1, P0
cmovge S2, P0
cmp P2, S1
cmovl P3, S1
