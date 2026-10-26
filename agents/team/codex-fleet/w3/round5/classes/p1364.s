# n=5 model=out iset=I1 prefix14_class=1364
mov S2, P3
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovl S1, P0
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
mov P0, P2
cmp P1, P0
cmovg P2, P1
cmovg P1, P0
cmp S1, S2
cmovle P0, S2
