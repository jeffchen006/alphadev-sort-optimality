# n=5 model=out iset=I1 prefix14_class=5785
mov S0, P3
cmp P1, P3
cmovl P3, P1
cmovg S0, P1
cmovg P1, P3
mov S1, P2
cmp S1, P0
cmovg S1, P0
cmovg P0, P2
cmp P1, S1
cmovle P1, S1
cmovl S1, P3
mov S1, P1
cmp P0, S0
