# n=5 model=out iset=I1 prefix14_class=3217
mov S0, P2
mov S2, P1
cmp P3, P2
cmovg S0, P3
cmovl P2, P3
cmp P0, S2
cmovge S2, P0
cmovl P1, P0
cmovg P0, P1
cmp P2, P0
cmovg P0, P2
cmovge P2, P1
mov P2, S2
cmp S0, S2
