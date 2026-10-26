# n=5 model=out iset=I1 prefix14_class=1905
cmp P2, P0
cmovl S2, P0
cmovle P0, P2
cmovl P2, S2
mov S1, P1
cmp P3, S1
cmovle P1, P3
cmovle P3, S1
cmovg S1, P3
cmp P3, P2
cmovg S1, P2
cmovg P2, P3
mov S0, S1
mov S2, P0
