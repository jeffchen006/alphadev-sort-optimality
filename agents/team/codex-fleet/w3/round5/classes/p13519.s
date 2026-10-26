# n=5 model=out iset=I1 prefix14_class=13519
mov S2, P0
cmp P0, P1
cmovl S2, P1
cmovle P1, P0
cmp P3, P2
mov P0, P1
cmovg S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P3, P1
cmovge P0, P3
cmovle P1, P3
cmp S2, P2
cmovl S1, P2
