# n=5 model=out iset=I1 prefix14_class=11310
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovl P2, P1
cmp P0, P3
cmovge P1, P0
cmovge P0, P3
mov S0, P0
cmovge P3, P1
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmovg P2, S1
cmp P0, S2
