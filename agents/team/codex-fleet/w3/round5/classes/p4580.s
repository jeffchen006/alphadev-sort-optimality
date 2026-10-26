# n=5 model=out iset=I1 prefix14_class=4580
cmp P2, P3
mov S2, P3
cmovg S2, P2
cmovle P3, P2
cmp P1, P0
mov S0, P0
cmovl P0, P1
cmovl P1, S0
mov S1, S2
cmp P1, S2
cmovl S1, P1
cmovle P1, S2
cmp P0, P3
cmovle P1, P3
