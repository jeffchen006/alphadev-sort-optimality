# n=5 model=out iset=I1 prefix14_class=204
cmp P3, P2
mov S1, P0
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
cmp S1, P1
cmovg P0, P1
cmovg P1, S1
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
mov S1, P1
cmovl P2, S2
cmp P1, P3
