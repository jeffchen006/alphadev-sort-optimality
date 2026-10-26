# n=5 model=out iset=I1 prefix14_class=10408
mov S0, P1
cmp P1, P0
cmovl P1, P0
mov S1, P3
cmovl P0, S0
cmp P2, S1
cmovl S1, P2
mov S2, P0
cmovg P3, P2
cmp P1, P3
cmovge P2, P1
cmovg P1, P3
cmovg P3, P2
mov P3, P1
