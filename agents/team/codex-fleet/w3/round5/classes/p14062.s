# n=5 model=out iset=I1 prefix14_class=14062
cmp P3, P0
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
mov S0, P3
mov S2, P2
cmp P1, S2
cmovle P2, P1
cmovle P1, S2
cmp S0, P1
cmovle P3, P1
cmovg S0, P1
cmp P2, P0
mov P1, P0
