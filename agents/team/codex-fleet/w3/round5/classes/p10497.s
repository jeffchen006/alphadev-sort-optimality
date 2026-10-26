# n=5 model=out iset=I1 prefix14_class=10497
cmp P0, P1
mov S2, P3
mov S1, P1
cmovle P1, P0
cmovl P0, S1
cmp P2, S2
cmovg S2, P2
cmovle P3, P2
cmp S2, P0
cmovle S0, P0
cmovle P0, S2
cmovl S2, S0
mov S1, P3
cmp P1, P3
