# n=5 model=out iset=I1 prefix14_class=6610
mov S2, P0
cmp S2, P2
cmovg S2, P2
cmovl P0, P2
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
mov S0, P1
mov P2, S2
cmp S0, P0
cmovl P1, P0
cmovg S0, P0
cmp P3, S2
