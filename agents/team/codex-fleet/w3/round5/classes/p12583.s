# n=5 model=out iset=I1 prefix14_class=12583
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovle S1, P1
mov S2, P3
cmp P2, P0
cmovle P1, P0
cmovl P0, P2
cmovl P2, P1
cmp P0, S2
cmovle P3, P0
mov P3, P2
cmovl P0, S2
cmp P2, S1
