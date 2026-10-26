# n=5 model=out iset=I1 prefix14_class=13694
mov S1, P0
cmp P0, P2
cmovg P0, P2
mov S0, P1
cmovl S1, P2
cmp P1, P3
cmovge S0, P3
cmovl P1, P3
cmp S0, P0
cmovge P2, S0
cmovg S0, P0
mov S2, S1
cmovg P0, P2
mov S0, P0
