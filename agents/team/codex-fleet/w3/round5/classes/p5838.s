# n=5 model=out iset=I1 prefix14_class=5838
cmp P2, P3
mov S2, P3
cmovl S2, P2
cmovge P3, P2
cmp P1, P0
mov P2, P1
cmovle P2, P0
cmovle P0, P1
cmp S2, P0
mov P1, S2
cmovl S2, P0
cmovge P1, P0
cmp P3, P2
cmovl P1, P3
