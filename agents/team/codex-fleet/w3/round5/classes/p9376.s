# n=5 model=out iset=I1 prefix14_class=9376
mov S1, P3
cmp P3, P2
cmovl S1, P2
cmovl P2, P3
cmp P0, P1
cmovle P3, P1
cmovl P1, P0
cmovl P0, P3
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
mov S2, P0
cmp S1, S2
