# n=5 model=out iset=I1 prefix14_class=2672
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovl S1, P1
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
cmovg S2, P3
cmp P2, P0
cmovl P3, P2
cmovge P3, P0
cmovle P2, P0
cmp S2, S1
cmovg P0, P3
