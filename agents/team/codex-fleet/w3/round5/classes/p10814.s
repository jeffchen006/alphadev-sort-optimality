# n=5 model=out iset=I1 prefix14_class=10814
mov S1, P3
cmp P2, S1
cmovg P3, P2
cmovl S1, P2
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
cmovle P1, P0
cmp P3, S2
cmovle P2, P3
cmovle P3, S2
cmovl S2, P2
mov P3, S1
cmp P1, S1
