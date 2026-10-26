# n=5 model=out iset=I1 prefix14_class=13357
cmp P1, P0
cmovl S0, P1
cmovle P1, P0
cmovl P0, S0
mov S1, P2
mov S2, P0
cmp P3, P2
cmovg P2, P3
cmovle S1, P3
cmp S1, S2
cmovle P0, S1
cmovg S2, S1
cmp P2, P1
cmovle S1, P2
