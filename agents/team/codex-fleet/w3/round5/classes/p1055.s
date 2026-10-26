# n=5 model=out iset=I1 prefix14_class=1055
mov S1, P3
mov S0, P0
cmp S0, P1
cmovl P0, P1
cmovl P1, S0
cmp S1, P2
cmovge S1, P2
cmovg P2, P3
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovge P0, S2
cmp S1, P1
mov S2, P1
