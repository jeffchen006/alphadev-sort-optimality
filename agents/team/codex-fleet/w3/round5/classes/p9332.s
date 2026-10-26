# n=5 model=out iset=I1 prefix14_class=9332
mov S1, P3
cmp P1, S1
cmovl P3, P1
cmovg S1, P1
cmp P0, P2
cmovle P1, P2
mov S2, P3
mov S0, S1
cmovle P2, P0
cmovl P0, P1
cmp S2, P2
cmovg S2, P2
cmovg P2, P3
cmp S0, P0
