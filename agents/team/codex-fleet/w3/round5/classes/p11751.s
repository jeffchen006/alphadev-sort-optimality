# n=5 model=out iset=I1 prefix14_class=11751
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
mov S0, P0
cmp P3, P1
mov S2, P3
cmovge S2, P1
cmovl P3, P1
cmp P3, S0
cmovge S0, P3
cmovl P0, P3
mov P3, P2
cmp S2, P2
