# n=5 model=out iset=I1 prefix14_class=6437
cmp P1, P3
mov S2, P3
cmovl S2, P1
cmovg P3, P1
mov S1, P2
cmp P0, S1
cmovg P2, P0
mov S0, P2
cmovl S1, P0
cmp P3, S0
cmovl P2, P3
cmovg S0, P3
cmp S1, S2
cmovle P3, S2
