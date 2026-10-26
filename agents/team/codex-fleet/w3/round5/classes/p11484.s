# n=5 model=out iset=I1 prefix14_class=11484
cmp P0, P2
mov S1, P2
cmovg S1, P0
cmovle P2, P0
mov S0, P3
cmp P3, P1
cmovl P3, P1
cmovg S0, P1
mov P1, P3
cmp S0, P2
cmovle P0, S0
cmovl S0, P2
cmovl P2, P0
cmp S1, P1
