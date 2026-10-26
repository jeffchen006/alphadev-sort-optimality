# n=5 model=out iset=I1 prefix14_class=5060
cmp P3, P0
mov S1, P0
cmovg S1, P3
cmovle P0, P3
mov S0, P2
cmp P1, S0
mov S2, S1
cmovl P2, P1
cmovg S0, P1
cmp P2, P0
cmovle P1, P0
cmovle P0, P2
cmovle P2, P1
cmp S2, S0
