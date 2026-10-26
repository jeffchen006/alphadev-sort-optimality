# n=5 model=out iset=I1 prefix14_class=11854
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovg S0, P0
cmp P2, P1
mov S1, P2
mov S2, S0
cmovl P2, P1
cmovl P1, S1
cmp P3, P2
cmovle P0, P2
cmovl P2, P3
cmovle P3, P0
cmp P1, S2
