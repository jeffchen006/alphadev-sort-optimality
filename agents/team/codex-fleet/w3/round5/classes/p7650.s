# n=5 model=out iset=I1 prefix14_class=7650
mov S2, P1
cmp P2, S2
cmovge S2, P2
mov S1, S2
mov S0, P3
cmovle P1, P2
cmp P0, S0
cmovl P3, P0
cmovge S0, P0
cmp P1, P3
cmovl P2, P1
cmovl P1, P3
cmovl P3, P2
cmp S0, S2
