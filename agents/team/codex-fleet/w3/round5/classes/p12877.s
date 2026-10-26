# n=5 model=out iset=I1 prefix14_class=12877
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P3, P0
cmovle S0, P3
cmovg S0, P0
cmovle P3, P0
cmovle P0, S0
cmp S0, P2
cmovg S0, P2
cmovle P0, P2
mov S2, P0
mov P2, P3
