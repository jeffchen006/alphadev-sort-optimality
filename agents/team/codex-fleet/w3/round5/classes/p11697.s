# n=5 model=out iset=I1 prefix14_class=11697
cmp P1, P0
cmovl S2, P1
cmovle P1, P0
mov S0, P2
cmovl P0, S2
cmp P3, P2
cmovl P2, P3
cmovg S0, P3
cmp P1, S0
mov P3, S0
cmovl S0, P1
cmovl P1, P3
cmp P2, P0
cmovg P3, P2
