# n=5 model=out iset=I1 prefix14_class=9184
cmp P2, P3
mov S0, P3
cmovl P3, P2
mov S1, P0
cmovge S0, P2
cmp P1, P0
cmovl P0, P1
cmovl P1, S1
cmp P3, P0
cmovge P2, P3
cmovg P3, P0
cmovg P0, P2
cmp P1, S0
cmovge P3, S0
