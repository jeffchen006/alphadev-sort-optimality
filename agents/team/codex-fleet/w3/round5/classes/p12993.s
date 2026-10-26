# n=5 model=out iset=I1 prefix14_class=12993
mov S0, P2
cmp P2, P3
mov S2, P1
cmovl S0, P3
cmovl P3, P2
cmp P0, P1
cmovl P1, P0
cmovl P0, S2
cmp P1, P3
mov S1, P0
cmovge S2, P3
cmovge P3, P1
cmovg P1, S2
cmp S1, S0
