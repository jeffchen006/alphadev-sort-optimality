# n=5 model=out iset=I1 prefix14_class=4311
mov S1, P2
cmp S1, P1
cmovg P2, P1
mov S2, P3
cmovl S1, P1
cmp P3, P0
cmovl S2, P0
cmovge P3, P0
cmp P2, P3
cmovle P1, P2
mov P0, S1
cmovle P2, P3
cmovle P3, P1
cmp S2, P0
