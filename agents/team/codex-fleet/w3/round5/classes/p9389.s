# n=5 model=out iset=I1 prefix14_class=9389
mov S1, P3
cmp S1, P0
cmovg P3, P0
cmovl S1, P0
cmp P2, P1
cmovge S2, P1
cmovl S2, P2
cmovl P2, P1
cmp S2, P3
cmovge P0, S2
cmovg S2, P3
cmovg P3, P0
mov S2, S1
cmp S2, P2
