# n=5 model=out iset=I1 prefix14_class=8047
cmp P1, P3
cmovge S1, P1
mov S2, P2
cmovge P1, P3
cmovg P3, S1
cmp P0, S2
cmovge S2, P0
cmovg P0, P2
cmovl P2, P0
cmp P2, P1
cmovl P0, P1
cmovg P2, P1
mov P2, S2
cmovge P1, P0
