# n=5 model=out iset=I1 prefix14_class=4493
mov S2, P2
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
mov S1, P0
cmp P0, P1
cmovl P0, P1
cmovge S1, P1
cmp S2, P0
cmovg P1, S2
cmovg S2, P0
cmovg P0, P1
cmp S1, P3
cmovge P0, S1
