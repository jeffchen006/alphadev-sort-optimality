# n=5 model=out iset=I1 prefix14_class=1397
cmp P1, P3
mov S0, P1
mov S2, P2
cmovg S0, P3
cmovg P3, P1
cmp S2, P0
cmovg S2, P0
cmovg P0, P2
cmp P3, P0
cmovl P1, P3
cmovl P3, P0
cmovl P0, P1
mov S1, S2
cmp S2, S0
