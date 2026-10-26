# n=5 model=out iset=I1 prefix14_class=6541
mov S2, P0
cmp P2, P0
mov S1, P3
cmovg S2, P2
cmovle P0, P2
cmp S1, P1
cmovl P3, P1
cmovle P1, S1
cmovle S1, P3
cmp P3, S2
cmovle S1, S2
cmovge P3, S2
cmp P1, P0
cmovl S2, P0
