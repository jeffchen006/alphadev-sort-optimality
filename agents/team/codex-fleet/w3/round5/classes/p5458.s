# n=5 model=out iset=I1 prefix14_class=5458
cmp P1, P2
cmovl S2, P1
cmovge S2, P2
cmovle P1, P2
mov S1, S2
mov P2, P0
cmp P3, P0
cmovge P0, P3
cmovg P3, P2
cmp P3, S1
cmovl S1, P3
cmovle P3, S2
cmp P1, P0
cmovg S2, P1
