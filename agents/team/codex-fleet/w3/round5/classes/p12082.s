# n=5 model=out iset=I1 prefix14_class=12082
mov S2, P2
cmp P2, P3
cmovg P2, P3
cmovl S2, P3
mov S1, P0
cmp S1, P1
mov S0, P2
cmovge S1, P1
cmovge P1, P0
cmp S1, S0
cmovl S0, S1
cmovg P2, S1
cmp P1, S2
mov S0, P2
