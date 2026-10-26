# n=5 model=out iset=I1 prefix14_class=1095
cmp P3, P0
mov S1, P3
cmovle P3, P0
mov S0, P2
mov S2, P3
cmovl P0, S1
cmp S0, P1
cmovg S0, P1
cmovl P2, P1
cmp S2, P2
cmovle P3, P2
cmovl P2, S2
mov S2, S0
cmp P0, S0
