# n=5 model=out iset=I1 prefix14_class=4762
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovle P3, S2
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovg P0, P2
mov S1, P3
cmp P0, P3
cmovge P3, P0
cmovg P0, S1
cmp S0, P1
cmovge S2, P1
