# n=5 model=out iset=I1 prefix14_class=8997
cmp P0, P1
mov S0, P2
cmovge S1, P1
cmovg P1, P0
cmovg P0, S1
cmp P2, P3
cmovge S0, P3
cmovl P2, P3
mov P3, P2
cmp P1, P2
cmovl P3, P1
cmovge P2, P1
cmp P0, S0
cmovg P2, S0
