# n=5 model=out iset=I1 prefix14_class=6160
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovg P3, P2
cmp P0, P1
cmovl S0, P0
cmovge S0, P1
cmovge P1, P0
cmp S2, P1
cmovge S1, P1
cmovg P1, S2
mov P1, P3
cmovge S2, S1
cmp S0, P1
