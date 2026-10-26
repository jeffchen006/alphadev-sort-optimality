# n=5 model=out iset=I1 prefix14_class=535
mov S1, P1
mov S0, P2
cmp S1, P3
cmovg P1, P3
cmovg P3, S1
cmp S0, P0
cmovg S0, P0
mov S2, P1
cmovg P0, P2
cmp S0, P1
cmovl S2, S0
mov S2, P0
cmovg P1, S0
cmp P3, P0
