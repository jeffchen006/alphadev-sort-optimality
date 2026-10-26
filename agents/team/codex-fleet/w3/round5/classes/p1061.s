# n=5 model=out iset=I1 prefix14_class=1061
mov S0, P0
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
mov S1, P2
cmp S1, P3
cmovge P2, P3
cmovg P3, S1
cmp P3, S0
cmovge S2, P3
cmovg P3, S0
cmovg S0, S2
mov S2, P1
cmp P2, P1
