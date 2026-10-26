# n=5 model=out iset=I1 prefix14_class=873
mov S0, P1
cmp P1, P2
mov S2, P0
cmovl P1, P2
cmovg S0, P2
cmp S2, P3
mov P2, P1
cmovg S2, P3
cmovg P3, P0
cmp P3, P2
cmovg P1, P3
cmovl P2, P3
cmp S2, S0
cmovl P0, S0
