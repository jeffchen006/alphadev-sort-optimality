# n=5 model=out iset=I1 prefix14_class=609
cmp P0, P1
cmovl S2, P1
cmovge S2, P0
cmovg P0, P1
mov S0, P3
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
mov P3, S2
mov S1, P0
cmp P2, P3
cmovg P3, P2
cmovl S2, P2
cmp S0, S1
