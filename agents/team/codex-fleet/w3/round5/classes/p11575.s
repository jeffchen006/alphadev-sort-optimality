# n=5 model=out iset=I1 prefix14_class=11575
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovle S0, P0
cmp P1, P3
cmovle S1, P3
mov P0, P2
cmovle P3, P1
cmovle P1, S1
cmp P3, P0
cmovl P0, P3
cmovl P3, P2
cmp P1, S0
mov S2, P3
