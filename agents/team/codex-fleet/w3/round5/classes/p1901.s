# n=5 model=out iset=I1 prefix14_class=1901
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
mov S1, P3
cmp P1, S1
cmovg P3, P1
cmovl S1, P1
cmp P2, P3
mov P1, P3
cmovle P1, P2
cmovl P2, P3
mov S2, P1
cmp P0, S1
