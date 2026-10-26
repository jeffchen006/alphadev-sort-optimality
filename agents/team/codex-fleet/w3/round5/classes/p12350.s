# n=5 model=out iset=I1 prefix14_class=12350
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovl P0, S1
cmp P1, P3
mov S2, P1
cmovge S2, P3
cmovle P1, P3
cmp P0, S2
cmovle S0, P0
cmovle P0, S2
cmovle S2, S0
cmp P1, P2
mov S2, P1
