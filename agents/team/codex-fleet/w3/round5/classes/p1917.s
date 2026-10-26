# n=5 model=out iset=I1 prefix14_class=1917
mov S2, P3
cmp P0, S2
cmovl S2, P0
cmovl P0, P3
cmp P2, P1
mov S0, P2
cmovl S0, P1
cmovle P1, P2
cmp P0, S0
mov S1, P0
cmovle P0, S0
cmovg S1, S0
mov P0, S1
cmp P1, S2
