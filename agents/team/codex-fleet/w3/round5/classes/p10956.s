# n=5 model=out iset=I1 prefix14_class=10956
cmp P1, P3
mov S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P0, P2
cmovg S1, P0
mov S2, P1
cmovg P0, P2
cmovg P2, S1
cmp P2, S2
cmovg S2, P2
cmovle P1, P2
cmp P3, P0
cmovl P2, P0
