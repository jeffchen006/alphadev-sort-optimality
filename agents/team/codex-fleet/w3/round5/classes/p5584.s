# n=5 model=out iset=I1 prefix14_class=5584
cmp P0, P3
mov S2, P3
mov S0, P2
cmovl P3, P0
mov S1, P3
cmovge S2, P0
cmp P2, P1
cmovle P2, P1
cmovge S0, P1
cmp S0, S1
cmovl S1, S0
cmovg P3, S0
cmp P2, S2
cmovge P1, P2
