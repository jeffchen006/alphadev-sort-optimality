# n=5 model=out iset=I1 prefix14_class=7203
mov S0, P1
cmp S0, P2
cmovge S0, P2
cmovl P1, P2
cmp P3, P0
cmovl P2, P3
cmovge P2, P0
cmovg P0, P3
cmp P2, S0
cmovge P3, S0
cmovl P3, P2
cmovl P2, S0
cmp P0, P1
cmovge S0, P1
