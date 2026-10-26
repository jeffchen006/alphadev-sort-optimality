# n=5 model=out iset=I1 prefix14_class=6750
mov S2, P2
mov S1, P0
cmp P3, P0
cmovge S1, P3
cmovg P3, P0
cmp P2, P1
cmovge S2, P1
cmovl P2, P1
cmp S1, P2
cmovge P1, S1
cmovge S1, P2
cmovge P2, P1
cmp P3, S2
cmovle P1, S2
