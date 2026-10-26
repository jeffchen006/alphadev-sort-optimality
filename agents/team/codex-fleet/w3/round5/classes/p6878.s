# n=5 model=out iset=I1 prefix14_class=6878
mov S2, P1
mov S1, P2
cmp P0, P2
cmovl S1, P0
cmovle P0, P2
cmp P1, P3
cmovl P1, P3
mov S0, P0
cmovl P3, S2
cmp P1, S0
cmovg S0, P1
cmovl P0, P1
cmp P3, S1
mov S0, P3
