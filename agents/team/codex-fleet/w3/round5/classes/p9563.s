# n=5 model=out iset=I1 prefix14_class=9563
cmp P1, P3
mov S0, P1
cmovle P1, P3
cmovl P3, S0
mov S2, P2
mov S0, P1
cmp P2, P0
cmovge S2, P0
cmovl P2, P0
cmp P2, P1
cmovg S0, P2
cmovl P1, P2
cmp S2, P3
cmovge S0, S2
