# n=5 model=out iset=I1 prefix14_class=3556
cmp P2, P0
mov S2, P3
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
cmp P3, P1
mov S1, P0
cmovle S2, P1
cmovle P1, P3
cmp P1, P0
cmovg P0, P1
cmovle S1, P1
cmp S2, P2
cmovg P3, S2
