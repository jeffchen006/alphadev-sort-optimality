# n=5 model=out iset=I1 prefix14_class=4272
cmp P2, P3
mov S1, P2
cmovl S1, P3
cmovge P2, P3
mov S2, P0
cmp P0, P1
cmovg P0, P1
cmovg P1, S2
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
cmovge S2, P0
cmovle P0, S2
mov P2, P1
