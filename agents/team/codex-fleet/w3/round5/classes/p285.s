# n=5 model=out iset=I1 prefix14_class=285
cmp P3, P0
mov S2, P3
cmovg P3, P0
mov S1, P2
cmovg P0, S2
cmp P1, S1
cmovl P2, P1
cmovg S1, P1
cmp P2, P3
mov S2, P3
cmovle P3, P2
cmovl P2, S2
cmp S1, P0
cmovle S0, P0
