# n=5 model=out iset=I1 prefix14_class=3615
cmp P1, P0
mov S0, P1
cmovle S0, P0
cmovle P0, P1
mov P1, P2
cmp P3, P1
cmovl P2, P3
cmovl P3, P1
mov S2, P2
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmp P3, S0
cmovle P2, P0
