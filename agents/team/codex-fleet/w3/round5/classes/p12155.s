# n=5 model=out iset=I1 prefix14_class=12155
cmp P0, P2
cmovge S2, P2
cmovge P2, P0
cmovge P0, S2
cmp P3, P1
mov S0, P1
cmovge S0, P3
cmovge P3, P1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
cmovge P0, P1
cmp P2, S0
cmovl P1, P2
