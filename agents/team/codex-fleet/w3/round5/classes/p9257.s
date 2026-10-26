# n=5 model=out iset=I1 prefix14_class=9257
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmovg S1, P1
cmp P3, P2
mov S0, P2
cmovle S0, P3
mov P1, S0
cmovg P2, P3
cmp S1, P1
cmovle P1, S1
cmovle S1, S0
cmp P0, P2
cmovl P1, P0
