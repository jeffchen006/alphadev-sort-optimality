# n=5 model=out iset=I1 prefix14_class=9968
mov S2, P1
cmp P1, P0
cmovg P1, P0
cmovge P0, S2
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
cmovg P2, S1
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmovge P2, S2
cmp P3, P1
cmovl S2, P3
