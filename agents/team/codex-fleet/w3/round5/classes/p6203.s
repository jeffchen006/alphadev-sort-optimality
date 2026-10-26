# n=5 model=out iset=I1 prefix14_class=6203
cmp P2, P3
mov S2, P3
mov S1, P1
cmovl P3, P2
cmovle P2, S2
cmp P0, S1
cmovg P1, P0
cmovle S1, P0
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
cmp S1, P3
mov P2, P3
