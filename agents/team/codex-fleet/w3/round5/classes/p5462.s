# n=5 model=out iset=I1 prefix14_class=5462
cmp P3, P2
cmovle S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P1, P0
mov S1, S2
cmovg P2, P0
cmovg P0, P1
cmovg P1, P2
cmp P1, S2
cmovl S1, P1
cmovl P1, S2
mov S2, P3
cmp P3, P0
