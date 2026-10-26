# n=5 model=out iset=I1 prefix14_class=6747
mov S1, P3
mov S2, P2
cmp P0, S1
cmovge S1, P0
cmovge P0, P3
cmp P2, P1
cmovge S2, P1
cmovl P2, P1
cmp S1, P2
cmovge P1, S1
cmovge S1, P2
cmovge P2, P1
cmp S2, P0
cmovg P1, S2
