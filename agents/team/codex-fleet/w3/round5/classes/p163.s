# n=5 model=out iset=I1 prefix14_class=163
mov S0, P2
cmp P2, P1
cmovge S0, P1
cmovle P2, P1
cmp P3, P0
mov P1, P0
cmovle P0, P3
cmovl P3, P1
cmp S0, P0
mov S1, P0
cmovg S1, S0
cmovge S0, P0
mov S0, P3
mov S2, S1
