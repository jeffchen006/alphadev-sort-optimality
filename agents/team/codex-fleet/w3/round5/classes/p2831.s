# n=5 model=out iset=I1 prefix14_class=2831
cmp P1, P0
cmovge S2, P1
cmovl S2, P0
cmovge P1, P0
cmp P2, P3
mov P0, P3
cmovge P0, P2
mov S1, S2
cmovle P3, P2
cmp S1, P0
cmovl S1, P0
cmovl P0, S2
cmp P1, P3
cmovl S2, P1
