# n=5 model=out iset=I1 prefix14_class=3136
cmp P1, P3
mov S1, P1
cmovg S1, P3
mov S2, P2
mov S0, S1
cmovg P3, P1
cmp P0, P2
cmovge S2, P0
cmovl P2, P0
cmp S1, P2
cmovl S0, P2
cmovge S1, P2
cmp S2, P3
cmovge P1, P3
