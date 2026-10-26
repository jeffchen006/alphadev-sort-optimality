# n=5 model=out iset=I1 prefix14_class=11417
cmp P0, P1
cmovl S2, P1
mov S1, P2
cmovle P1, P0
cmovl P0, S2
mov S0, P1
cmp P2, P3
cmovg P2, P3
cmovg P3, S1
cmp S0, P2
cmovle P1, P2
cmovg S0, P2
mov S0, P0
cmp S0, P3
