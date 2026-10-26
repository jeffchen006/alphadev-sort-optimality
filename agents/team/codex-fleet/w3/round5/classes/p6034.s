# n=5 model=out iset=I1 prefix14_class=6034
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmovg S2, P2
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
cmp P0, P2
cmovge P2, P0
cmovl S2, P0
cmp P1, P3
cmovl P2, P1
