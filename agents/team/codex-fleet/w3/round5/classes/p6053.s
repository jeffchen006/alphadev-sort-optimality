# n=5 model=out iset=I1 prefix14_class=6053
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovle P1, S2
mov S0, P2
cmp P0, S0
cmovl P2, P0
cmovl P0, S0
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P2, P1
cmovl S2, P2
