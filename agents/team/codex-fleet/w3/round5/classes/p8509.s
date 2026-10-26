# n=5 model=out iset=I1 prefix14_class=8509
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov S1, P1
cmovl P0, S0
cmp S1, P2
cmovl S1, P2
cmovle P2, P1
cmovle P1, S1
cmp P0, S1
cmovle P1, P0
cmovg S1, P0
mov S1, P3
mov P0, P1
