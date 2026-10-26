# n=5 model=out iset=I1 prefix14_class=14269
cmp P3, P2
cmovle S1, P3
cmovge S1, P2
cmovle P3, P2
cmp P1, P0
mov S0, P3
cmovle P2, P0
mov S2, S1
cmovle P0, P1
cmovle P1, P2
cmp P3, P1
cmovle P3, P1
cmovl P1, S0
mov P3, P1
