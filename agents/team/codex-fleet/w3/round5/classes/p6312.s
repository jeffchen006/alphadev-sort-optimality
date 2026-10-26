# n=5 model=out iset=I1 prefix14_class=6312
cmp P3, P1
cmovge S2, P1
cmovle S2, P3
cmovge P1, P3
mov S1, P0
cmp P2, S1
cmovge S1, P2
cmovl P0, P2
cmp S1, P1
cmovge P3, P1
cmovg P1, S1
cmovge S1, P3
cmp P0, S2
cmovg P1, S2
