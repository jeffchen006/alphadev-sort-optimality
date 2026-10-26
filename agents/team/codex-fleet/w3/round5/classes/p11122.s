# n=5 model=out iset=I1 prefix14_class=11122
cmp P2, P0
cmovle S1, P2
mov S2, P1
cmovl P2, P0
cmovle P0, S1
cmp P3, P1
cmovle P1, P3
cmovle P3, S2
cmp P2, P3
mov S0, P2
cmovge S0, P3
cmovle P2, P3
cmp P1, P0
cmovle P2, P1
