# n=5 model=out iset=I1 prefix14_class=10383
cmp P1, P2
cmovle S1, P1
mov S2, P3
cmovl P1, P2
cmovl P2, S1
cmp P0, S2
cmovge S2, P0
cmovle P3, P0
mov P0, P1
cmp P1, S2
cmovl P0, S2
cmovge P1, S2
mov S2, P2
cmp P2, P3
