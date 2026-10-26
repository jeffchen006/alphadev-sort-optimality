# n=5 model=out iset=I1 prefix14_class=12814
mov S0, P2
cmp P3, P0
mov S2, P3
cmovl S2, P0
cmovl P0, P3
cmp S0, P1
cmovg S0, P1
cmovg P1, P2
cmp S0, P0
cmovge P3, S0
cmovge S0, P0
cmovge P0, P3
mov S0, P1
cmp S2, P1
