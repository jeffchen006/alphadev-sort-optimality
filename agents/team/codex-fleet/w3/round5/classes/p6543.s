# n=5 model=out iset=I1 prefix14_class=6543
cmp P2, P3
cmovge S2, P2
cmovle S2, P3
mov S1, P0
cmovle P3, P2
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
mov P0, S1
cmp S1, S2
cmovg S1, S2
cmovl P0, S2
cmp P1, P3
cmovle P0, P3
