# n=5 model=out iset=I1 prefix14_class=9425
cmp P2, P3
cmovl S2, P3
mov S1, P1
cmovle P3, P2
cmovl P2, S2
cmp P0, S1
cmovle P1, P0
cmovg S1, P0
cmp P1, P3
cmovg P0, P1
cmovg P1, P3
mov S0, S1
cmovg P3, P0
cmp P2, S1
