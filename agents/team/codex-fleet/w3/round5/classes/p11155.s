# n=5 model=out iset=I1 prefix14_class=11155
cmp P2, P1
cmovle S1, P2
mov S0, P0
cmovle P2, P1
cmovle P1, S1
cmp P0, P3
cmovg S0, P3
cmovge P3, P0
cmovle P0, P3
cmp P3, P2
cmovge P0, P2
cmovl P3, P2
cmp S0, P1
cmovge S2, P1
