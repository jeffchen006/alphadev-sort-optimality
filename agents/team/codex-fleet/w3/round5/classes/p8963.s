# n=5 model=out iset=I1 prefix14_class=8963
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
mov S1, P2
cmovl P0, S0
cmp S1, P1
cmovle P2, P1
cmovle P1, S1
cmp P3, P2
mov S1, P2
cmovl P2, P3
cmovg S1, P3
cmp P0, P1
cmovg P3, P1
