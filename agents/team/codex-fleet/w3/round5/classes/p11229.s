# n=5 model=out iset=I1 prefix14_class=11229
mov S1, P1
cmp P1, P2
cmovge P1, P2
cmovge P2, S1
mov S0, P0
cmp P3, P0
cmovl S0, P3
cmovl P3, P0
mov S2, P2
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmp P1, S0
cmovge S2, S0
