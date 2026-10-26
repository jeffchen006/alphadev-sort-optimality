# n=5 model=out iset=I1 prefix14_class=2139
mov S0, P3
cmp P0, P3
cmovl S0, P0
cmovl P0, P3
cmp P1, P2
mov S1, P1
cmovg S1, P2
mov S2, P0
cmovle P1, P2
cmp S2, P1
cmovl P0, P1
cmovle P1, S2
mov P0, S0
cmp S0, S1
