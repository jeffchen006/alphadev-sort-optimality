# n=5 model=out iset=I1 prefix14_class=11324
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P0, P1
cmovg S2, P1
cmovg P1, P0
cmovg P0, S2
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
mov S2, P2
cmp P0, P2
