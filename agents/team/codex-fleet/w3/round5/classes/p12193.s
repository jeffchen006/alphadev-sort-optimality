# n=5 model=out iset=I1 prefix14_class=12193
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
mov S0, P3
cmovle S2, P2
cmp P3, P0
cmovle P3, P0
cmovge S0, P0
cmp S2, S0
cmovle S1, S2
cmovge S1, S0
cmovg S0, S2
cmp P1, P3
cmovge S1, P1
