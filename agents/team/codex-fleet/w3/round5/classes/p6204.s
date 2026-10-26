# n=5 model=out iset=I1 prefix14_class=6204
cmp P0, P3
mov S2, P3
mov S1, P1
cmovle P3, P0
cmovl P0, S2
cmp P2, S1
cmovg P1, P2
cmovle S1, P2
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp S1, P3
mov P0, P3
