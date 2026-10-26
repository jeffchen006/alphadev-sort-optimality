# n=5 model=out iset=I1 prefix14_class=3970
mov S1, P2
cmp P2, P3
mov S2, P1
cmovl P2, P3
cmovl P3, S1
cmp P0, P1
cmovg S2, P0
cmovle P1, P0
cmp P1, P3
cmovg S1, P3
mov S0, S2
cmovg P3, P1
cmovg P1, S1
cmp P2, S2
