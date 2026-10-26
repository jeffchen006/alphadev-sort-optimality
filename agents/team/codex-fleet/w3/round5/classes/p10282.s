# n=5 model=out iset=I1 prefix14_class=10282
cmp P1, P0
mov S1, P1
cmovl P1, P0
cmovge S1, P0
cmp P2, P3
cmovg S2, P3
cmovg P3, P2
cmovg P2, S2
mov S0, P1
mov P0, P2
cmp P3, S0
cmovge P1, P3
cmovl S0, P3
cmp S1, P0
