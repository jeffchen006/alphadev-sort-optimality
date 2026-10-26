# n=5 model=out iset=I1 prefix14_class=5650
cmp P3, P2
mov S2, P3
cmovl S2, P2
cmovle P2, P3
mov S0, P0
cmp P0, P1
cmovg P0, P1
mov S1, P2
cmovle S0, P1
cmp S1, P0
cmovle S1, P0
cmovl P0, P2
cmp S2, S0
cmovle P2, S1
