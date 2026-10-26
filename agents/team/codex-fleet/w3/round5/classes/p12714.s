# n=5 model=out iset=I1 prefix14_class=12714
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P0, P1
mov S2, P1
cmovge P1, P0
mov S0, P3
cmovg P0, S2
cmp P3, P2
