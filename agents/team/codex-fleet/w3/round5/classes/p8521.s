# n=5 model=out iset=I1 prefix14_class=8521
cmp P2, P3
cmovle S0, P3
mov S2, P0
cmovle P3, P2
cmovl P2, S0
cmp S2, P1
cmovle S2, P1
cmovl P1, P0
cmovle P0, S2
cmp P2, S2
cmovg P0, P2
cmovle S2, P2
mov S1, P3
cmp P3, P1
