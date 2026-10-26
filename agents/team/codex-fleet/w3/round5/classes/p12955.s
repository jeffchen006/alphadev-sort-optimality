# n=5 model=out iset=I1 prefix14_class=12955
cmp P3, P0
cmovg S0, P0
mov S1, P2
cmovg P0, P3
cmovg P3, S0
cmp P1, P2
cmovg S1, P1
cmovl P2, P1
cmovg P1, P2
cmp P3, P1
cmovg P1, P3
cmovg P3, P2
mov P3, S1
cmp S1, P0
