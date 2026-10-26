# n=5 model=out iset=I1 prefix14_class=7774
mov S0, P3
cmp P3, P2
cmovge S0, P2
mov S1, P0
cmovl P3, P2
cmp P0, P1
cmovl S1, P1
cmovg P0, P1
cmp P0, S0
cmovge P2, S0
cmovge S0, P0
cmovg P0, P2
mov P0, P3
cmp P0, S1
