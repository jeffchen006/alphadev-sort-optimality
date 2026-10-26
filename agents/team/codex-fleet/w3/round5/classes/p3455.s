# n=5 model=out iset=I1 prefix14_class=3455
mov S0, P2
cmp P1, S0
cmovge S0, P1
cmovg P1, P2
mov S2, P3
cmp S2, P0
cmovg P3, P0
cmovl S2, P0
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
mov P0, S2
cmp S0, S2
