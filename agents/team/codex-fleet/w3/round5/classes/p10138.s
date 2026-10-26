# n=5 model=out iset=I1 prefix14_class=10138
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
cmovl P1, S2
mov S1, P0
cmp P0, P3
cmovge S1, P3
cmovle P0, P3
mov P3, P0
cmp P2, P3
cmovg P3, P2
mov S0, S1
cmovl P0, P2
mov P3, P0
