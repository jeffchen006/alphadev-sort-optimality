# n=5 model=out iset=I1 prefix14_class=7627
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovl S1, P3
cmp P1, P2
cmovle P3, P1
cmovg P3, P2
cmovg P2, P1
cmp S1, P3
cmovl P1, P3
cmovle P3, S1
cmovl S1, P1
cmp P0, P2
mov P3, P2
