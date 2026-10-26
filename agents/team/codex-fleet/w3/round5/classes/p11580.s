# n=5 model=out iset=I1 prefix14_class=11580
cmp P2, P3
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovg S2, P0
cmp P3, S2
mov S1, S2
cmovle S1, P3
cmovl P3, S2
cmp P1, P2
cmovl P0, P2
