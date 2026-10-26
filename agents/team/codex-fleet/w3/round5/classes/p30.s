# n=5 model=out iset=I1 prefix14_class=30
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovl P1, S1
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
mov S1, P0
cmovge P2, S2
cmp S1, P3
cmovl S1, P3
cmovge P0, P3
mov P0, P2
cmp P2, P1
