# n=5 model=out iset=I1 prefix14_class=10940
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
mov S2, P3
cmp P0, P1
cmovg S0, P0
cmovg P0, P1
cmovg P1, S0
cmp P1, P3
cmovl S2, P1
cmovg P3, P1
cmp P2, P0
cmovl P1, P0
