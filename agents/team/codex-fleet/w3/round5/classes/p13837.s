# n=5 model=out iset=I1 prefix14_class=13837
mov S1, P1
mov S2, P2
cmp P2, P3
cmovge S2, P3
cmovl P2, P3
cmp P0, S1
cmovle S1, P0
cmovge P1, P0
cmp P2, P1
cmovge P0, P1
cmovle P0, P2
cmovg P1, P2
cmp S2, S1
cmovge P2, P0
