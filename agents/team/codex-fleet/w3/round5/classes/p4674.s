# n=5 model=out iset=I1 prefix14_class=4674
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
mov S2, P1
cmp P2, S2
cmovl P1, P2
cmovl P2, S2
cmp P2, P0
mov S2, P0
cmovge P0, P2
cmovge P2, S2
mov P0, P1
cmp P0, P3
