# n=5 model=out iset=I1 prefix14_class=8338
cmp P3, P1
cmovl S1, P3
cmovge S1, P1
cmovle P3, P1
cmp P2, P0
cmovg S2, P0
mov P1, S1
cmovg P0, P2
cmovg P2, S2
cmp S1, P2
cmovge P1, P2
mov P1, P3
cmovl S1, P2
cmp P1, P0
