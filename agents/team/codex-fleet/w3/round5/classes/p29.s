# n=5 model=out iset=I1 prefix14_class=29
mov S1, P0
cmp P3, S1
cmovle P0, P3
cmovl P3, S1
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
mov S1, P0
cmovge P2, S2
cmp S1, P1
cmovl S1, P1
cmovge P0, P1
mov P0, P2
cmp P2, P3
