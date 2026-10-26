# n=5 model=out iset=I1 prefix14_class=648
cmp P0, P2
cmovge S1, P2
cmovl S1, P0
cmovl P0, P2
mov P2, P3
cmp P2, P1
cmovge P3, P1
cmovle P2, P1
mov S2, P2
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
cmp P3, S1
mov S2, S1
