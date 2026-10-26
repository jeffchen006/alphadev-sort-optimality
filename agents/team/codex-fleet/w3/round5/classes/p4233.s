# n=5 model=out iset=I1 prefix14_class=4233
mov S1, P0
cmp P1, P0
cmovge P0, P1
mov S0, P3
cmovg P1, S1
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
cmp P1, P2
cmovl S1, P2
cmovl P2, P1
cmovge S1, P1
cmp P3, P0
cmovge S0, P3
