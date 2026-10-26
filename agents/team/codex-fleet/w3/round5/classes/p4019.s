# n=5 model=out iset=I1 prefix14_class=4019
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovg S1, P3
cmovl P3, S1
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovge S2, P2
cmp S1, P0
cmovle P3, P0
cmovge S1, P0
cmp P1, S2
cmovge P2, S2
