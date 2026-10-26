# n=5 model=out iset=I1 prefix14_class=7472
cmp P1, P3
cmovle S2, P1
cmovg S2, P3
cmovg P3, P1
cmp P0, P2
mov P1, P2
cmovl P2, P0
cmovle P0, P1
cmp S2, P2
cmovle S1, P2
cmovl P2, S2
cmovl S2, S1
cmp P0, P3
cmovge S1, P3
