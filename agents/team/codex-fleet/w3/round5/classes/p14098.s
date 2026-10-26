# n=5 model=out iset=I1 prefix14_class=14098
mov S0, P2
mov S1, P1
cmp P3, S1
cmovge S1, P3
cmovg P3, P1
cmp S0, P0
mov S2, P3
cmovge P2, P0
cmovle S0, P0
cmp S0, S1
cmovle P0, S1
cmovle S1, S0
cmovle S0, P0
cmp P2, S2
