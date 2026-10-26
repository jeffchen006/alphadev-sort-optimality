# n=5 model=out iset=I1 prefix14_class=12884
mov S2, P1
cmp S2, P3
cmovle P1, P3
cmovl P3, S2
cmovg S2, P3
cmp P2, P0
mov S0, P1
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
cmp S2, P0
cmovg S2, P0
cmovl P3, P0
mov S2, P3
