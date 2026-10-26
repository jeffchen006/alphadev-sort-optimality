# n=5 model=out iset=I1 prefix14_class=766
mov S1, P1
cmp P0, P1
cmovl S1, P0
mov S0, P2
cmovl P0, P1
cmp S0, P3
cmovg S0, P3
cmovl P2, P3
cmp P2, P0
cmovle P1, P0
cmovg P1, P2
cmovl P0, P2
mov P1, S1
cmp P1, S0
