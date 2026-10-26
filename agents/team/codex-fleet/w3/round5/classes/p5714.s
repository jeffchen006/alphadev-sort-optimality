# n=5 model=out iset=I1 prefix14_class=5714
cmp P1, P2
cmovle S2, P2
cmovg S2, P1
cmovl P2, P1
mov P1, P3
cmp P0, P1
cmovg P3, P0
cmovl P1, P0
cmp P1, P2
cmovge S1, P1
cmovle S1, P2
cmovg P1, P2
cmp S2, P3
cmovle P2, P3
