# n=5 model=out iset=I1 prefix14_class=2330
mov S1, P3
mov S0, P2
cmp P2, P1
cmovl P2, P1
cmovg S0, P1
cmp S1, P0
cmovge S1, P0
cmovle P3, P0
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovg S2, P2
cmp S1, S0
cmovle P0, S0
