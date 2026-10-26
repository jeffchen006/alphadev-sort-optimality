# n=5 model=out iset=I1 prefix14_class=2594
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
mov S2, P2
cmp S2, P0
cmovg P2, P0
cmovl S2, P0
mov S1, S2
cmp S2, P3
cmovg S1, P3
cmovl S2, P3
cmp P1, P2
mov S2, P2
