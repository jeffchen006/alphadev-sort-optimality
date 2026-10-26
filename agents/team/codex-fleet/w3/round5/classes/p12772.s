# n=5 model=out iset=I1 prefix14_class=12772
mov S0, P2
cmp P1, P2
mov S2, P3
cmovl S0, P1
cmovl P1, P2
cmp P0, P3
mov S1, P1
cmovge P3, P0
cmovg P0, S2
cmp S0, P0
cmovl P2, P0
cmovl P0, S0
cmovl S0, P2
mov S2, S0
