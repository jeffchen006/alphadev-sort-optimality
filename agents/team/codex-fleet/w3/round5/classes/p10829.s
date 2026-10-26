# n=5 model=out iset=I1 prefix14_class=10829
mov S2, P2
cmp S2, P0
mov S1, P1
cmovl P2, P0
cmovge S2, P0
cmp P3, S1
cmovg S1, P3
cmovge P3, P1
cmp P2, S1
cmovg P0, P2
cmovge P2, S1
cmovg S1, P0
cmp P3, S2
mov S1, P3
