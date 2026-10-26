# n=5 model=out iset=I1 prefix14_class=13546
cmp P1, P0
mov S0, P1
cmovle P1, P0
cmovge S0, P0
cmp P3, P2
mov S1, S0
cmovle S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P2, S1
cmovle S1, P2
cmovle P2, S0
mov S1, P3
cmp P1, P3
