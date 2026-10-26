# n=5 model=out iset=I1 prefix14_class=8546
mov S2, P0
cmp S2, P3
cmovle P0, P3
cmovl P3, S2
mov S0, P1
mov S1, P0
cmp P2, P1
cmovl P1, P2
cmovge S0, P2
cmp S0, S1
cmovg S1, S0
cmovl P0, S0
cmp P1, P3
cmovge S2, P3
