# n=5 model=out iset=I1 prefix14_class=4688
mov S0, P0
cmp P2, S0
cmovl S0, P2
mov S2, P1
cmovg P0, P2
cmp S2, P3
cmovl S2, P3
cmovg P1, P3
mov S1, S0
cmp P0, S2
cmovg P2, S2
cmovg S2, P0
cmovg P0, P2
cmp S1, P1
