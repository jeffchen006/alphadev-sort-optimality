# n=5 model=out iset=I1 prefix14_class=200
cmp P0, P3
mov S1, P2
cmovle S2, P0
cmovl P0, P3
cmovle P3, S2
cmp P2, P1
cmovg S1, P1
mov S2, P0
cmovg P1, P2
cmp S1, P3
cmovle S0, S1
cmovl S1, P3
cmovl P3, S0
cmp S2, P1
