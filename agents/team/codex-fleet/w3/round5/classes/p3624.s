# n=5 model=out iset=I1 prefix14_class=3624
mov S1, P0
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovle P3, S0
cmp P1, P0
cmovle P0, P1
mov S2, P2
cmovl P1, S1
cmovle S1, P0
cmp P3, S1
cmovg P0, P3
cmovl S1, P3
cmp S2, P1
