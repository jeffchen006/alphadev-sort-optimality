# n=5 model=out iset=I1 prefix14_class=5461
cmp P0, P2
cmovle S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
mov S1, S2
cmovg P2, P3
cmovg P3, P1
cmovg P1, P2
cmp P1, S2
cmovle S1, P1
cmovl P1, S2
cmp P0, P3
mov S2, P0
