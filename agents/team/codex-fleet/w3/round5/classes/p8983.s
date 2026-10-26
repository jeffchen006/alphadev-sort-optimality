# n=5 model=out iset=I1 prefix14_class=8983
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
mov S2, P1
cmovg P3, S0
cmp P1, P0
cmovge P1, P0
cmovge P0, S2
cmovl S2, P0
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
cmovge P2, P0
mov S2, P1
