# n=5 model=out iset=I1 prefix14_class=1195
cmp P3, P0
mov S2, P2
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P2, P1
mov S1, P3
cmovl S2, P1
cmovge P2, P1
cmp S1, S2
cmovg S1, S2
cmovg S2, P3
cmp P2, P0
cmovle P1, P2
