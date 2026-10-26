# n=5 model=out iset=I1 prefix14_class=2990
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovg S1, P2
cmp P3, P0
mov S0, P3
mov S2, S1
cmovge P3, P0
cmovg P0, S0
cmp S1, P0
cmovg S2, P0
cmovg P0, S1
cmp P1, P3
cmovge S0, P1
