# n=5 model=out iset=I1 prefix14_class=3714
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovg S1, P3
cmovl P3, S1
mov S2, P2
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
cmp S1, P0
cmovl P3, P0
cmovl P0, S1
cmp P1, P2
cmovg S0, P2
