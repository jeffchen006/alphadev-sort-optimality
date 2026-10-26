# n=5 model=out iset=I1 prefix14_class=7287
mov S2, P0
cmp P2, P0
cmovge S2, P2
cmovle P0, P2
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
mov S0, P1
cmp S0, P0
cmovg S0, P0
cmovge P0, P1
cmp S2, P3
cmovle S1, P3
