# n=5 model=out iset=I1 prefix14_class=11343
cmp P0, P1
cmovle S0, P1
mov S2, P3
cmovl P1, P0
cmovle P0, S0
cmp S2, P2
cmovg P3, P2
cmovle S2, P2
cmp P0, S2
cmovg P2, P0
cmovle P2, S2
cmovle S2, P0
cmp P3, P1
cmovl P2, P1
