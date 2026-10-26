# n=5 model=out iset=I1 prefix14_class=14334
cmp P1, P2
mov S1, P3
cmovg S2, P1
cmovg P1, P2
cmovg P2, S2
cmp S1, P0
cmovl P3, P0
cmovg S1, P0
cmp P1, S1
cmovl P0, S1
cmovle S1, P1
mov S2, P3
cmovl P1, P0
cmp P2, P3
