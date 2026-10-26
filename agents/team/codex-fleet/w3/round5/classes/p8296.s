# n=5 model=out iset=I1 prefix14_class=8296
mov S1, P2
cmp P2, P0
cmovg S1, P0
cmovge P0, P2
cmp P3, P1
cmovle P2, P1
cmovl P1, P3
cmovle P3, P2
cmp S1, P1
cmovle S0, S1
cmovle S1, P1
cmovg S0, P1
cmp P3, P0
cmovle S2, P3
