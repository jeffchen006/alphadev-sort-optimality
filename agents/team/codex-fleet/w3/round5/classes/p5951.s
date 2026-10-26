# n=5 model=out iset=I1 prefix14_class=5951
cmp P2, P3
cmovge S2, P3
mov S1, P1
cmovl S2, P2
cmovg P3, P2
cmp P1, P0
cmovle P1, P0
cmovg S1, P0
mov P2, P3
cmp P2, P1
cmovg P3, P1
cmovl P2, P1
mov P2, S2
cmovle P1, P3
