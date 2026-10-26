# n=5 model=out iset=I1 prefix14_class=534
mov S1, P1
mov S0, P2
cmp S1, P3
cmovg P1, P3
cmovge P3, S1
cmp S0, P0
cmovg P2, P0
cmovge P0, S0
mov S2, P1
cmp P2, P1
cmovl S2, P2
mov S2, P3
cmovg P1, P2
cmp P0, P3
