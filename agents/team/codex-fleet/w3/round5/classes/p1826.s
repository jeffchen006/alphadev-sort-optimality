# n=5 model=out iset=I1 prefix14_class=1826
cmp P0, P2
cmovge S2, P2
cmovge P2, P0
mov S0, P1
cmovge P0, S2
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp P1, P2
cmovge S0, P2
cmovl S0, P1
cmovl P1, P2
cmp P3, P0
mov P2, P0
