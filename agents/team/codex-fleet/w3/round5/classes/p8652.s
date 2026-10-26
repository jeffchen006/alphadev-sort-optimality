# n=5 model=out iset=I1 prefix14_class=8652
mov S2, P2
cmp P2, P0
cmovg S2, P0
cmovl P2, P0
cmp P3, P1
mov S0, P2
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp S0, P3
cmovge P2, P3
cmovge P3, S0
cmp P1, S2
cmovg S1, S2
