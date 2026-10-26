# n=5 model=out iset=I1 prefix14_class=12312
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
mov S1, P0
cmovle P1, P2
cmp P3, S1
cmovle S1, P3
cmovg P0, P3
cmp S1, S0
cmovge S2, S1
cmovg S1, S0
cmovge S0, S2
mov S1, P0
cmp S1, P1
