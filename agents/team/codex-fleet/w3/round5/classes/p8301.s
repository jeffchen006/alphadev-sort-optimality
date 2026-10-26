# n=5 model=out iset=I1 prefix14_class=8301
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovl P0, S0
mov S1, P2
cmp P1, P2
cmovle P2, P1
mov S2, P0
cmovg S1, P1
cmp S2, P2
cmovge P0, P2
cmovle S2, P2
cmp S1, P3
cmovge P0, P3
