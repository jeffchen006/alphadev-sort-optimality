# n=5 model=out iset=I1 prefix14_class=9864
mov S0, P1
cmp P2, P1
cmovl S0, P2
cmovg P1, P2
cmp P0, P3
cmovg S1, P3
cmovg P3, P0
cmovg P0, S1
mov S2, P1
cmp P3, P1
cmovl P1, P3
cmovle P3, S2
cmp P0, S0
cmovg S2, P0
