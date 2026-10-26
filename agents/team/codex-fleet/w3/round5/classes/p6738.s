# n=5 model=out iset=I1 prefix14_class=6738
mov S1, P0
mov S2, P3
cmp P2, S1
cmovg S1, P2
cmovg P2, P0
cmp P3, P1
cmovl S2, P1
cmovg P3, P1
cmp S1, S2
cmovg P1, S1
cmovg S1, S2
cmovg S2, P1
cmp P2, P3
cmovge P1, P2
