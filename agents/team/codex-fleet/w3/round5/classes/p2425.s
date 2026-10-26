# n=5 model=out iset=I1 prefix14_class=2425
mov S2, P0
cmp P2, P0
mov S0, P3
cmovl P0, P2
cmovg S2, P2
cmp S0, P1
cmovle P3, P1
mov S1, P3
cmovl P1, S0
cmp S2, P3
cmovge S1, S2
mov S1, P0
cmovg S2, P3
cmp P1, P0
