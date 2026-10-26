# n=5 model=out iset=I1 prefix14_class=6509
mov S2, P2
mov S1, P0
cmp P1, S2
cmovle P2, P1
cmovg S2, P1
cmp P3, P0
cmovle P0, P3
cmovl P3, S1
mov P1, P3
cmp S2, P1
cmovl P1, S2
cmovle S2, P3
cmp P2, P0
cmovl S0, P0
