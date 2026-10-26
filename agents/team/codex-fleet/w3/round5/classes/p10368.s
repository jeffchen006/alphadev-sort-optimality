# n=5 model=out iset=I1 prefix14_class=10368
mov S0, P0
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovl P1, S2
cmp S0, P3
cmovle P0, P3
cmovg S0, P3
cmovle P3, S0
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P1, S0
