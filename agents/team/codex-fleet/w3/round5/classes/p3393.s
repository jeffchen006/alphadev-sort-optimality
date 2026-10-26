# n=5 model=out iset=I1 prefix14_class=3393
mov S2, P2
cmp P1, P3
cmovge S1, P3
cmovle S1, P1
cmovge P3, P1
cmp P0, S2
cmovg S2, P0
cmovl P2, P0
mov S0, P2
cmp S1, P2
cmovg S0, S1
cmovg S1, P2
cmp P3, S2
cmovle P1, S2
