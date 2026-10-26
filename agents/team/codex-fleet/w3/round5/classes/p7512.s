# n=5 model=out iset=I1 prefix14_class=7512
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovg S0, P2
cmp P3, P1
cmovl P2, P1
cmovge P2, P3
cmovge P3, P1
cmp P0, P3
cmovle S1, P0
mov S2, P2
cmovl P0, P3
cmovle P3, S1
cmp S2, S0
