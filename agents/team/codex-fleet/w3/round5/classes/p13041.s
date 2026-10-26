# n=5 model=out iset=I1 prefix14_class=13041
mov S0, P3
cmp P2, P3
cmovl S0, P2
cmovg P3, P2
cmp P0, P1
cmovl P2, P0
cmovle P0, P1
cmovl P1, P2
mov S2, P1
cmp P1, S0
cmovl P1, S0
cmovl S0, S2
cmp P0, P3
cmovg S0, P3
