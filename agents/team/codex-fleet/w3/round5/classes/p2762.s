# n=5 model=out iset=I1 prefix14_class=2762
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovge P0, P2
mov P2, P1
cmp P2, P3
cmovle P1, P3
cmovge P2, P3
cmp S2, P1
cmovl P3, P1
cmovle P1, S2
cmovl S2, P3
mov S2, P0
cmp P0, P2
