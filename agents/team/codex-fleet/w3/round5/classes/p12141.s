# n=5 model=out iset=I1 prefix14_class=12141
cmp P0, P3
mov S0, P3
cmovge P3, P0
mov S1, P2
cmovl S0, P0
cmp P1, S1
cmovge P2, P1
cmovge P1, S1
cmp S0, P1
cmovg P0, S0
cmovge S0, P1
mov S1, P3
cmovg P1, P0
mov S2, P1
