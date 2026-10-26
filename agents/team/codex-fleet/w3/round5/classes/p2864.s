# n=5 model=out iset=I1 prefix14_class=2864
cmp P2, P0
mov S1, P3
mov S2, P0
cmovl P0, P2
cmovg S2, P2
cmp P1, P3
cmovg S1, P1
mov P2, S2
cmovge P1, P3
cmp S1, P2
cmovl S2, S1
cmovg P2, S1
cmp P1, P0
cmovg S1, S2
