# n=5 model=out iset=I1 prefix14_class=1125
cmp P3, P0
mov S2, P0
cmovl P0, P3
mov S1, P2
cmovg S2, P3
cmp P1, S1
cmovg S1, P1
cmovge P1, P2
cmp S2, S1
cmovge P2, S2
cmovle P2, S1
cmovle S1, S2
cmp P0, P1
cmovle S0, P1
