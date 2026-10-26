# n=5 model=out iset=I1 prefix14_class=1837
cmp P3, P0
mov S1, P2
mov S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P1, S1
cmovge P2, P1
cmovg P1, S1
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovl P2, P0
cmp P3, P1
cmovg P2, P1
