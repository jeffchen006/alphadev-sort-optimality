# n=5 model=out iset=I1 prefix14_class=1761
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmp P3, P0
mov P2, P3
cmovge P2, P0
cmovl P3, P0
cmp S0, P3
cmovl S2, S0
cmovl S0, P3
cmovge S2, P3
mov S0, P1
cmp S0, P2
