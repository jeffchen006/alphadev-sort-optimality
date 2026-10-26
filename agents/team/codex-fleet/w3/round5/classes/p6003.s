# n=5 model=out iset=I1 prefix14_class=6003
mov S1, P2
mov S0, P1
cmp S1, P3
cmovg S1, P3
cmovl P2, P3
cmp P0, P1
cmovl P1, P0
cmovg S0, P0
mov S2, S0
cmp P2, S0
cmovge S2, P2
cmovg P2, S0
cmp P1, S1
cmovl S2, S1
