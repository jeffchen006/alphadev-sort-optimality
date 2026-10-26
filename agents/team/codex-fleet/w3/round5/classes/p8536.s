# n=5 model=out iset=I1 prefix14_class=8536
cmp P2, P3
cmovl S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P0, P1
mov S0, P1
cmovle S0, P0
cmovl P0, P1
cmp P2, P0
mov P1, P0
cmovg P0, P2
cmovle P1, P2
cmp S0, P3
cmovle P0, P3
