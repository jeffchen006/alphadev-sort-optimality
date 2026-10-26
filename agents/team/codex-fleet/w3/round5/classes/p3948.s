# n=5 model=out iset=I1 prefix14_class=3948
mov S0, P1
cmp P1, P0
mov S1, P3
cmovle P1, P0
cmovg S0, P0
cmp S1, P2
cmovl P3, P2
cmovle P2, S1
cmp S0, P2
cmovle P0, S0
cmovle S0, P2
mov S2, P3
cmovl P2, P0
cmp P3, P1
