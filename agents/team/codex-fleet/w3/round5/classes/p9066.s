# n=5 model=out iset=I1 prefix14_class=9066
cmp P2, P3
cmovg S2, P3
mov S1, P0
cmovg P3, P2
cmovg P2, S2
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
mov S0, P2
cmovl P0, S1
cmp S1, P3
cmovle P0, P3
cmovl P3, S1
mov P0, P3
