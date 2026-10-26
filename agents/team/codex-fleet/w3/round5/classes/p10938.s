# n=5 model=out iset=I1 prefix14_class=10938
cmp P0, P2
mov S1, P2
cmovl P2, P0
cmovle P0, S1
mov S0, P0
cmp P3, P1
cmovg S2, P3
cmovg P3, P1
cmovg P1, S2
cmp P1, P0
cmovl S0, P1
cmovg P0, P1
cmp P2, P3
cmovle P1, P3
