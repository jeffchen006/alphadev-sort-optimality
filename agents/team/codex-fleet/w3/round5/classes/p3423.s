# n=5 model=out iset=I1 prefix14_class=3423
mov S2, P1
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmovle S0, P2
mov S1, P3
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
mov P3, S0
cmp S2, S0
