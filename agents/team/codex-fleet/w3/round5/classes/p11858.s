# n=5 model=out iset=I1 prefix14_class=11858
mov S1, P3
mov S2, P0
cmp P1, P0
cmovg S2, P1
cmovle P0, P1
cmp S1, P2
cmovge S1, P2
cmovle P3, P2
cmp S2, P3
cmovl P2, S2
cmovle S2, P3
cmovl P3, P2
cmp P0, S1
cmovl P1, P0
