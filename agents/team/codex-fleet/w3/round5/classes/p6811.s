# n=5 model=out iset=I1 prefix14_class=6811
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp P2, P1
mov S1, P1
cmovle P1, P2
mov S2, P1
cmovg S1, P2
cmp S1, P3
cmovle P2, P3
cmovl P3, S1
cmovg P2, S1
cmovg S1, P3
