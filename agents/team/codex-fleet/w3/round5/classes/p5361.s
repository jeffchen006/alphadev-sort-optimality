# n=5 model=out iset=I1 prefix14_class=5361
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
mov S2, P0
cmovle S1, P3
cmp P1, S2
cmovg S2, P1
cmovle P0, P1
cmovge P1, P0
cmp P2, P1
cmovge P1, P2
cmovl P0, P2
cmp S1, S2
cmovle P2, P1
