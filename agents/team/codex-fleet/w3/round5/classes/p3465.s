# n=5 model=out iset=I1 prefix14_class=3465
mov S1, P0
cmp P1, S1
cmovg P0, P1
cmovg P1, S1
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovl S0, P2
cmp P1, P3
mov S2, S0
cmovg P2, P3
cmovge P3, P1
cmovg P1, P2
cmp P0, S0
