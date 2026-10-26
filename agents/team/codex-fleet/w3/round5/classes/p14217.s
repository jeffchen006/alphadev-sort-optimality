# n=5 model=out iset=I1 prefix14_class=14217
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovg P2, S1
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovl P3, S2
mov S2, P1
cmp S2, P2
