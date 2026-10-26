# n=5 model=out iset=I1 prefix14_class=11808
mov S2, P3
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
mov S0, P1
cmovl P0, S1
cmp P2, P1
cmovl S0, P2
cmovg P1, P2
cmp P0, S2
mov P2, S2
