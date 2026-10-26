# n=5 model=out iset=I1 prefix14_class=11719
cmp P3, P0
mov S1, P0
cmovg S1, P3
mov S2, P1
cmovl P0, P3
cmp S2, P2
cmovg S2, P2
cmovl P1, P2
cmp P1, S1
cmovge P2, P1
cmovg P1, S1
cmovge S1, P2
cmp S2, P0
cmovge P3, S2
