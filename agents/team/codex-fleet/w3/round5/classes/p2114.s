# n=5 model=out iset=I1 prefix14_class=2114
cmp P0, P1
cmovge S1, P1
mov S2, P2
cmovg P1, P0
cmovl S1, P0
cmp P2, P3
cmovl S2, P3
cmovge P2, P3
cmp P1, S2
cmovge P3, S2
cmovg S2, P1
cmovge P1, P3
cmp P2, S1
cmovge P0, P2
