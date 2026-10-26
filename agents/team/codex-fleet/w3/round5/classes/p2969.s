# n=5 model=out iset=I1 prefix14_class=2969
cmp P0, P1
mov S1, P2
mov S2, P1
cmovge S2, P0
cmovl P1, P0
cmp S1, P3
cmovge P2, P3
cmovge P3, S1
cmp P3, S2
mov S1, S2
cmovl S2, P3
cmovl P3, S1
cmp P2, P1
cmovg P3, P1
