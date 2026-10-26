# n=5 model=out iset=I1 prefix14_class=6748
mov S1, P3
mov S2, P2
cmp P0, S1
cmovge S1, P0
cmovg P0, P3
cmp P2, P1
cmovge S2, P1
cmovl P2, P1
cmp S1, P2
cmovge P1, S1
cmovge S1, P2
cmovge P2, P1
cmp P0, S2
cmovg P1, P0
