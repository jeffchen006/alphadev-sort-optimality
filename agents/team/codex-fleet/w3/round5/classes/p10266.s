# n=5 model=out iset=I1 prefix14_class=10266
cmp P3, P2
mov S1, P2
cmovg S1, P3
cmovl P2, P3
mov S0, P0
cmovl P3, S1
cmp S0, P1
cmovle P0, P1
cmovg S0, P1
cmp P3, P0
cmovl P3, P0
cmovl P0, S1
cmp P2, S0
cmovle S2, S0
