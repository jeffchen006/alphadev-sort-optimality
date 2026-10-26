# n=5 model=out iset=I1 prefix14_class=13962
cmp P0, P3
mov S0, P1
mov S1, P0
cmovg S1, P3
cmovl P0, P3
cmp P2, S0
cmovle S0, P2
cmovg P1, P2
cmp P1, P0
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
cmp S0, S1
cmovle P2, S0
