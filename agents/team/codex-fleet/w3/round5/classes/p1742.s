# n=5 model=out iset=I1 prefix14_class=1742
mov S1, P2
cmp S1, P1
cmovle S1, P1
cmovle P1, P2
mov P2, P0
cmp P2, P3
cmovg P2, P3
cmovl P0, P3
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
cmovge S2, P1
cmovg P1, P2
cmp P0, S1
