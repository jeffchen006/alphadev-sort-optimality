# n=5 model=out iset=I1 prefix14_class=1000
mov S2, P2
cmp P1, S2
cmovl P2, P1
cmovge S2, P1
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
mov S1, P0
cmp S2, P0
mov P1, P2
cmovg P0, S2
cmovge S2, S1
cmp P3, P2
