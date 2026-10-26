# n=5 model=out iset=I1 prefix14_class=12607
mov S0, P1
cmp P3, S0
cmovl S0, P3
cmovle P3, P1
cmp P0, P2
mov S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P2, S0
cmovle P1, S0
cmovl S0, P2
cmovle P2, P1
cmp P0, P3
cmovg S0, P3
