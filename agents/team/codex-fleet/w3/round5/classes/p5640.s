# n=5 model=out iset=I1 prefix14_class=5640
mov S2, P1
mov S1, P3
cmp P1, P0
cmovl S2, P0
cmovg P1, P0
cmp P2, S1
cmovl S1, P2
cmovg P3, P2
cmp S1, P1
cmovge P0, P1
cmovg P1, S1
mov P2, S2
cmovg S1, P0
cmp P2, P3
