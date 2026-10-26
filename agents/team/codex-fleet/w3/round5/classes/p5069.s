# n=5 model=out iset=I1 prefix14_class=5069
mov S1, P1
cmp S1, P3
cmovl S1, P3
mov S2, P2
cmovl P3, P1
cmp P0, P2
cmovle P2, P0
mov P1, P3
cmovge S2, P0
cmp P1, P2
cmovg P3, P2
mov P3, S2
cmovle P1, P2
mov P2, P1
