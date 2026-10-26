# n=5 model=out iset=I1 prefix14_class=11313
mov S2, P3
cmp S2, P2
cmovge S2, P2
cmovl P3, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
mov S0, P1
cmovge P0, P2
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
cmp S0, S2
