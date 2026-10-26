# n=5 model=out iset=I1 prefix14_class=2785
mov S2, P3
mov S1, P1
cmp P0, S1
cmovge S1, P0
cmovg P0, P1
cmp P3, P2
cmovge S2, P2
cmovl P3, P2
cmp S1, P3
cmovl P2, P3
cmovge P2, S1
cmovg S1, P3
cmp P0, S2
cmovl P1, P0
