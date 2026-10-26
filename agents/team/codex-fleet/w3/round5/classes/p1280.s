# n=5 model=out iset=I1 prefix14_class=1280
cmp P0, P3
cmovg S1, P3
cmovge P3, P0
cmovg P0, S1
cmp P2, P1
mov S0, P2
cmovl S0, P1
mov S2, P3
cmovl P1, P2
cmp S2, S0
cmovl S2, S0
cmovg P3, S0
cmp P0, P1
cmovg S2, P0
