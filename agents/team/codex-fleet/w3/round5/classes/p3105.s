# n=5 model=out iset=I1 prefix14_class=3105
cmp P0, P3
cmovg S1, P0
cmovle S1, P3
cmovle P3, P0
mov S0, P2
mov S2, P3
cmp P1, S0
cmovge S0, P1
cmovl P2, P1
cmp P3, P2
cmovle S2, P2
cmovge P3, P2
cmp S1, S0
cmovge P0, S0
