# n=5 model=out iset=I1 prefix14_class=10274
mov S2, P2
cmp P2, P0
cmovg P2, P0
mov S1, P3
cmovle S2, P0
cmp P1, S1
cmovge S1, P1
cmovle P3, P1
cmp S1, S2
mov S0, S1
cmovge S1, S2
cmovge S2, S0
cmp P3, P2
cmovle P1, P2
