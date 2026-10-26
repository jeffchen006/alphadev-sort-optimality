# n=5 model=out iset=I1 prefix14_class=10713
mov S0, P0
cmp P2, S0
mov S2, P1
cmovge P0, P2
cmovl S0, P2
cmp P1, P3
cmovg P1, P3
cmovg P3, S2
cmp P3, P0
cmovg P2, P0
cmovge P0, P3
cmovg P3, P2
mov S1, S0
cmp S1, P1
