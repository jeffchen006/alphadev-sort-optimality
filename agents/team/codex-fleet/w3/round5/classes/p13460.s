# n=5 model=out iset=I1 prefix14_class=13460
cmp P3, P1
cmovl S2, P3
mov S0, P0
cmovle P3, P1
cmovl P1, S2
cmp S0, P2
cmovle P0, P2
cmovg S0, P2
mov P2, S0
cmp S0, P1
cmovle P2, P1
cmovle P1, S0
cmp P3, P0
cmovg S1, P0
