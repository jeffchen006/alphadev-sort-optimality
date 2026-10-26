# n=5 model=out iset=I1 prefix14_class=5074
mov S2, P1
cmp S2, P3
cmovle P1, P3
cmovle P3, S2
cmp P2, P0
cmovle S0, P2
mov S1, P3
cmovge S0, P0
cmovg P0, P2
cmp S1, S0
cmovge S1, S0
cmovge S0, P3
cmp P1, P0
cmovge S1, P0
