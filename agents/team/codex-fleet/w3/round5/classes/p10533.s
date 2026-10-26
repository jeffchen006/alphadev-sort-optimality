# n=5 model=out iset=I1 prefix14_class=10533
cmp P1, P3
mov S2, P1
mov S1, P2
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
mov S0, P3
cmovg P2, P0
cmovg P0, S1
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
mov P2, P1
