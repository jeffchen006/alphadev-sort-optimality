# n=5 model=out iset=I1 prefix14_class=9212
cmp P0, P3
cmovge S2, P3
cmovle S2, P0
cmovle P0, P3
mov S1, P2
cmp P1, S1
cmovge S1, P1
cmovl P2, P1
cmp S2, P2
cmovge P1, S2
mov S0, S1
cmovg S2, P2
cmovge P2, P1
cmp P0, S0
