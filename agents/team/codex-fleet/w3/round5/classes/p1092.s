# n=5 model=out iset=I1 prefix14_class=1092
cmp P3, P0
mov S1, P3
cmovle P3, P0
cmovl P0, S1
mov S2, P1
cmp S2, P2
cmovge S2, P2
mov S0, P3
cmovle P1, P2
cmp S0, P1
cmovle P3, P1
cmovl P1, S0
cmp S2, P0
mov S0, P0
