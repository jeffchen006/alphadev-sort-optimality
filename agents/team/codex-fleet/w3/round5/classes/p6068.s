# n=5 model=out iset=I1 prefix14_class=6068
cmp P2, P0
mov S2, P3
mov S1, P0
cmovl P0, P2
cmovge S1, P2
cmp P3, P1
cmovle P3, P1
cmovl P1, S2
cmovle S2, P3
cmp S1, P3
cmovl P3, S1
cmovle S1, S2
cmp P0, P1
cmovg S1, P0
