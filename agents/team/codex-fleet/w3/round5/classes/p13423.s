# n=5 model=out iset=I1 prefix14_class=13423
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovge P0, S2
cmp P2, P1
mov S1, P1
cmovl S1, P2
cmovge P1, P2
mov P2, S1
cmp S1, P3
cmovl S1, P3
cmovle P3, P2
cmp P0, P1
cmovge P2, P0
