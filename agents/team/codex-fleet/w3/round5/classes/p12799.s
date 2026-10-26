# n=5 model=out iset=I1 prefix14_class=12799
mov S2, P2
cmp P3, P2
cmovl S2, P3
cmovg P2, P3
mov S1, P0
cmp P0, P1
cmovg P0, P1
cmovg P1, S1
cmp S2, P0
cmovg P3, S2
cmovg S2, P0
cmovg P0, P3
mov S2, P2
cmp S2, P1
