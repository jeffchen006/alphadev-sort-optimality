# n=5 model=out iset=I1 prefix14_class=77
cmp P1, P3
mov S2, P0
cmovl S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P2, S2
cmovg S2, P2
cmovl P0, P2
cmovge P2, P0
cmp P0, P1
cmovge P0, P1
cmovg P1, P2
mov P0, S2
cmp S2, S1
