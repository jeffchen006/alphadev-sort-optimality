# n=5 model=out iset=I1 prefix14_class=13106
cmp P0, P3
mov S2, P3
cmovle S2, P0
cmovle P0, P3
cmp P1, P2
cmovl P3, P1
cmovl P1, P2
cmovl P2, P3
mov S1, P2
cmp S1, S2
cmovle P2, S2
cmovle S2, S1
mov S1, P2
mov S0, P0
