# n=5 model=out iset=I1 prefix14_class=639
cmp P2, P3
cmovle S1, P2
mov S2, P1
cmovge S1, P3
cmovl P2, P3
cmp P1, P0
cmovge P1, P0
cmovge P0, S2
cmovle S2, P0
cmp S2, P2
cmovle P0, P2
cmovl P2, S2
cmp P1, S1
cmovge P0, S1
