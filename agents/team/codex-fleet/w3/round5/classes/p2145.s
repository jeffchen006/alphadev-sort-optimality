# n=5 model=out iset=I1 prefix14_class=2145
mov S1, P3
cmp P1, P2
mov S0, P2
cmovl P2, P1
cmovl P1, S0
cmovg S0, P1
cmp P0, S1
cmovl P3, P0
cmovl P0, S1
cmp P1, P0
cmovl P1, P0
cmovle P0, S0
cmp P3, P2
cmovl P1, P3
