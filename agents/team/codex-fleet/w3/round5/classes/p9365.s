# n=5 model=out iset=I1 prefix14_class=9365
mov S2, P0
cmp S2, P3
cmovl P0, P3
cmovl P3, S2
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
mov S1, P3
cmovl P2, S0
cmp P1, S1
cmovg P3, P1
cmovge P1, S1
mov S1, P3
mov P1, P0
