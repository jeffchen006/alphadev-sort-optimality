# n=5 model=out iset=I1 prefix14_class=13104
mov S1, P1
cmp P0, P1
cmovge S1, P0
cmovl P1, P0
mov S0, P3
cmp P2, P3
mov S2, P1
cmovl S0, P2
cmovle P2, P3
cmp S0, P1
cmovl P1, S0
cmovge S2, S0
cmp P2, S1
cmovge P1, P2
