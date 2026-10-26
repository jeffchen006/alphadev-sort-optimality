# n=5 model=out iset=I1 prefix14_class=5605
mov S1, P2
cmp S1, P1
cmovg S1, P1
cmovl P2, P1
cmovl P1, S1
cmp P0, P3
cmovl S0, P0
cmovle P0, P3
cmovl P3, S0
cmp P1, P3
cmovg P1, P3
cmovg P3, S1
cmp P2, P0
mov P1, P0
