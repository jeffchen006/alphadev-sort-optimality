# n=5 model=out iset=I1 prefix14_class=5481
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
cmovl P3, S1
mov S2, P0
cmp S2, P2
cmovle P0, P2
mov S0, P1
cmovg S2, P2
cmp P1, S2
cmovle S0, S2
cmovl S2, P1
cmp P0, P3
cmovg P1, P0
