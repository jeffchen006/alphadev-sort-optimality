# n=5 model=out iset=I1 prefix14_class=12767
cmp P2, P1
mov S2, P1
cmovge S2, P2
cmovg P2, P1
cmp P0, P3
cmovl P1, P3
cmovl P3, P0
cmovl P0, P1
mov S1, P3
cmp P2, P3
cmovg P3, P2
cmovge P2, S1
cmp P0, S2
cmovl S0, S2
