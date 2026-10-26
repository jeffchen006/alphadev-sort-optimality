# n=5 model=out iset=I1 prefix14_class=12091
cmp P3, P0
cmovg S1, P3
cmovge P3, P0
cmovle S1, P0
cmp P2, P1
mov S2, P2
cmovg S2, P1
cmovl P2, P1
cmp S2, P3
cmovl P1, P3
cmovle P3, S2
cmovl S2, P1
cmp S1, P2
cmovle P1, S1
