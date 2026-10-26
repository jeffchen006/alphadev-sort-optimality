# n=5 model=out iset=I1 prefix14_class=1068
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovl P1, S2
mov S0, P3
cmp S0, P2
cmovge S0, P2
cmovg P2, P3
mov S2, S0
cmp P2, P0
cmovg P3, P2
cmovge P2, P0
cmovg P0, P3
cmp P1, S2
