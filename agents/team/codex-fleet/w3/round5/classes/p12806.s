# n=5 model=out iset=I1 prefix14_class=12806
cmp P0, P2
mov S2, P1
mov S1, P2
cmovl P2, P0
cmovge S1, P0
cmp S2, P3
cmovge S2, P3
cmovge P3, P1
cmp S2, P2
cmovge P0, S2
cmovg S2, P2
cmovge P2, P0
cmp P3, S1
mov S2, P3
