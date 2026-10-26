# n=5 model=out iset=I1 prefix14_class=4077
cmp P1, P0
mov S1, P3
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
mov S2, P0
cmp P2, S1
cmovg P3, P2
cmovg P2, S1
cmovg S1, P3
cmp S2, P2
cmovg P0, P2
cmovle S2, P2
cmp S1, P1
