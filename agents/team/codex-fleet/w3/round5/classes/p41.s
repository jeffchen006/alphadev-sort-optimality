# n=5 model=out iset=I1 prefix14_class=41
mov S1, P2
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovle P1, S0
cmp P3, P2
cmovl P2, P3
mov S0, P0
cmovg S1, P3
mov S2, S1
cmp P0, P2
cmovl S0, P2
cmovg P0, P2
cmp S2, P1
