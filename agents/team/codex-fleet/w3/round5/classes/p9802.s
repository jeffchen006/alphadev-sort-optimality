# n=5 model=out iset=I1 prefix14_class=9802
cmp P1, P2
cmovg S2, P1
cmovle S2, P2
cmovg P1, P2
cmp P0, P3
cmovle S1, P0
cmovge S1, P3
cmovle P0, P3
cmovge P3, P0
cmp S2, P0
cmovl P3, S2
cmovge P0, S2
cmp P1, S1
cmovg S2, P3
