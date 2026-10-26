# n=5 model=out iset=I1 prefix14_class=11464
mov S0, P3
cmp S0, P1
cmovg S0, P1
cmovle P3, P1
cmp P2, P0
mov S1, P3
mov S2, S0
cmovle P1, P2
cmovle P2, P0
cmovl P0, P1
cmp P0, S0
cmovle S2, P0
cmovl P0, S0
cmp P2, P3
