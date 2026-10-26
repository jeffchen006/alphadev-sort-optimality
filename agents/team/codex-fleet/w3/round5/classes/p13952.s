# n=5 model=out iset=I1 prefix14_class=13952
cmp P1, P3
cmovle S2, P1
cmovg S2, P3
cmovle P1, P3
cmp P0, P2
cmovge S1, P2
cmovl S1, P0
cmovge P2, P0
cmp P2, P1
cmovle P3, P1
cmovle P1, P2
cmovl P2, P3
cmp S2, S1
cmovl P2, S2
