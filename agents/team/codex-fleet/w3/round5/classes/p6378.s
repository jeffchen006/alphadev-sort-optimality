# n=5 model=out iset=I1 prefix14_class=6378
cmp P0, P3
cmovle S0, P3
mov S2, P2
cmovge S0, P0
cmovl P3, P0
cmp P1, P2
cmovle P2, P1
cmovge S2, P1
cmovl P1, S2
cmp S0, S2
cmovge S2, S0
cmovle P1, S0
cmp P3, P2
cmovg S0, P3
