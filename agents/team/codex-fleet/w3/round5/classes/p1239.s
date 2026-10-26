# n=5 model=out iset=I1 prefix14_class=1239
cmp P2, P0
cmovle S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
mov S2, S0
cmovge S1, P1
cmovle S1, P3
cmovle P3, P1
cmp S0, S1
mov P2, P3
cmovge S2, S1
cmovg S1, S0
cmp P3, P0
