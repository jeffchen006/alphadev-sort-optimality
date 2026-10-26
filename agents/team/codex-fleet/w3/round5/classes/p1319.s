# n=5 model=out iset=I1 prefix14_class=1319
mov S0, P3
cmp P2, S0
cmovge S0, P2
cmovle P3, P2
cmovle P2, S0
mov S2, P0
cmp S2, P1
cmovge S2, P1
cmovg P1, P0
cmp P1, S0
cmovge S0, P1
cmovl P2, P1
mov P1, P2
cmp S2, P3
