# n=5 model=out iset=I1 prefix14_class=167
mov S1, P2
cmp S1, P3
cmovg S1, P3
cmovl P2, P3
mov S2, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, S2
cmp S1, P0
cmovle S0, P0
cmovg S0, S1
cmovg S1, P0
cmp P2, P1
cmovg S1, P2
