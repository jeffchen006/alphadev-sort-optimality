# n=5 model=out iset=I1 prefix14_class=7407
mov S0, P2
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P2, P0
cmovg S0, P0
mov S1, S0
cmovg P0, P2
cmp P3, S1
cmovg S0, P3
cmovg P3, S1
cmp P0, P1
cmovl P3, P1
