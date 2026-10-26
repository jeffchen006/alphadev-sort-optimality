# n=5 model=out iset=I1 prefix14_class=536
mov S1, P3
mov S0, P2
cmp S1, P1
cmovg P3, P1
cmovg P1, S1
mov S2, P3
cmp S0, P0
cmovg P2, P0
cmovg P0, S0
cmp P2, P3
cmovl S2, P2
cmovge P3, P2
mov S2, P0
cmp P1, P0
