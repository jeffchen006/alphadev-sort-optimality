# n=5 model=out iset=I1 prefix14_class=246
mov S2, P3
cmp P2, S2
cmovl P3, P2
mov S1, P1
cmovg S2, P2
cmovge P2, P3
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmp S1, P3
cmovle P3, S1
cmovl S1, P2
cmp P0, S2
cmovge P1, P0
