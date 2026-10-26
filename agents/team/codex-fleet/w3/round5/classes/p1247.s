# n=5 model=out iset=I1 prefix14_class=1247
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
cmovl P3, P1
cmp S1, S2
cmovle P1, S2
cmovg P1, S1
cmovle S2, S1
cmp P2, P3
cmovge P0, P2
