# n=5 model=out iset=I1 prefix14_class=11837
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
mov S2, P0
mov S1, P3
cmp P3, P2
cmovle P3, P2
cmovl P2, S1
cmp P3, P0
cmovg P0, P3
cmovl S2, P3
cmp P2, P1
cmovg S0, P1
