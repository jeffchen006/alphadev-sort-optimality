# n=5 model=out iset=I1 prefix14_class=2093
cmp P3, P0
mov S0, P0
cmovg P0, P3
cmovle S0, P3
mov S1, P1
cmp S1, P2
cmovle P1, P2
cmovge S1, P2
cmp P0, P1
cmovg S2, P0
cmovle S2, P1
cmovg P0, P1
cmp S1, S0
cmovle S2, S1
