# n=5 model=out iset=I1 prefix14_class=11782
cmp P3, P0
mov S0, P0
cmovg P0, P3
mov S1, P1
cmovg P3, S0
cmp P2, S1
cmovg S1, P2
cmovl P1, P2
cmp P0, S1
cmovg S0, S1
cmovg S1, P0
mov S1, P1
cmovg P0, S0
cmp P3, S1
