# n=5 model=out iset=I1 prefix14_class=9307
cmp P0, P1
mov S0, P0
cmovle P0, P1
cmovg S0, P1
cmp P2, P3
cmovle P1, P3
cmovl P3, P2
cmovl P2, P1
cmp P3, S0
mov S1, S0
cmovl S0, P3
cmovg S1, P3
cmp P2, P0
cmovg S0, P0
