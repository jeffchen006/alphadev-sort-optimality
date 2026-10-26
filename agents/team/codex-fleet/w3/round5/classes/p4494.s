# n=5 model=out iset=I1 prefix14_class=4494
mov S2, P2
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovge S1, P1
cmp S2, P3
cmovg P1, S2
cmovg S2, P3
cmovg P3, P1
cmp S1, P0
cmovge P3, S1
