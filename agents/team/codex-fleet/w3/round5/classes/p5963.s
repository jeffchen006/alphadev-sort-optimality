# n=5 model=out iset=I1 prefix14_class=5963
cmp P1, P2
cmovle S2, P2
cmovg S2, P1
mov S0, P0
cmovl P2, P1
cmp S0, P3
cmovle S0, P3
mov P1, S0
cmovge P0, P3
cmp P1, S2
cmovge S0, S2
cmovle P1, S2
cmp P0, P2
cmovge S1, P0
