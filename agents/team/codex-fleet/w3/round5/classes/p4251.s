# n=5 model=out iset=I1 prefix14_class=4251
cmp P0, P3
cmovle S1, P3
mov S2, P2
cmovg S1, P0
cmovle P3, P0
cmp P1, S2
cmovge P2, P1
cmovge P1, S2
mov S2, P1
cmp P3, P1
cmovg S2, P3
cmovl P1, P3
cmp S1, P2
cmovge P3, S1
