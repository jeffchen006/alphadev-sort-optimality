# n=5 model=out iset=I1 prefix14_class=8729
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovg P0, P2
cmp P1, P3
cmovle P2, P1
cmovl P1, P3
cmovle P3, P2
mov S0, P0
mov S2, P1
cmp S1, S2
cmovle P1, S1
cmovg S2, S1
cmp P0, P3
