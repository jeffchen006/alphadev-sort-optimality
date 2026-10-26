# n=5 model=out iset=I1 prefix14_class=5654
mov S1, P0
cmp P0, P2
cmovl P0, P2
cmovl P2, S1
cmovge S1, P2
cmp P3, P1
mov S2, P3
cmovle S2, P1
cmovg P3, P1
cmp S1, P3
cmovle S1, P3
cmovle P3, P2
cmp P0, S2
cmovle P1, P0
