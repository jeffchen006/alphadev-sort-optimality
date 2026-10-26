# n=5 model=out iset=I1 prefix14_class=10149
mov S1, P2
cmp P2, P1
mov S2, P3
cmovle P2, P1
cmovl P1, S1
cmp P3, P0
cmovg S2, P0
mov S0, P2
cmovl P3, P0
cmp P3, P2
cmovg P2, P3
cmovg P3, S0
cmp P1, S2
cmovg S0, S2
