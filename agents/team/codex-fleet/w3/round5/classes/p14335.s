# n=5 model=out iset=I1 prefix14_class=14335
mov S1, P2
cmp S1, P0
cmovg P2, P0
mov S0, P1
cmovg P0, S1
cmp P1, P3
cmovle P1, P3
cmovle P3, S0
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P1, P0
cmovle P3, P0
