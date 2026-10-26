# n=5 model=out iset=I1 prefix14_class=3732
mov S2, P2
cmp P2, P1
cmovl S2, P1
mov S1, P3
cmovl P1, P2
cmp P0, P3
cmovg P3, P0
cmovg P0, S1
cmp P0, P1
cmovge P2, P1
cmovg P1, P0
cmovg P0, P2
mov S0, S2
cmp P3, S0
