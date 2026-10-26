# n=5 model=out iset=I1 prefix14_class=10693
mov S2, P3
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmovl P3, P1
cmp P2, P1
cmovl P1, P2
cmovl P2, P3
cmp S2, P0
mov P3, S2
