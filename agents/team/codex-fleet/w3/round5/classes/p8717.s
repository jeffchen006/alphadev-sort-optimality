# n=5 model=out iset=I1 prefix14_class=8717
cmp P1, P3
mov S2, P1
cmovg S2, P3
cmovg P3, P1
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
mov S0, P0
cmovl P2, S1
cmp P3, S0
cmovl S0, P3
cmovg P0, P3
mov P1, S2
cmp P1, P2
