# n=5 model=out iset=I1 prefix14_class=10304
mov S0, P0
cmp P0, P2
cmovl P0, P2
cmovge S0, P2
cmp P1, P3
cmovge P2, P3
mov S2, P0
cmovge P3, P1
cmovg P1, P2
cmp P3, S2
cmovg S2, P3
cmovl P0, P3
cmp S0, P1
mov S2, S0
