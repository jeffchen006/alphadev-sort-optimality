# n=5 model=out iset=I1 prefix14_class=13312
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovg P1, S0
cmp P0, P3
cmovl S2, P3
cmovl P3, P0
cmovge S2, P0
mov P0, P1
cmp P3, P1
cmovge P0, P3
cmovle P1, P3
mov P3, P0
cmp S2, P2
