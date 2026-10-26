# n=5 model=out iset=I1 prefix14_class=2292
mov S1, P3
mov S2, P2
cmp P2, P0
cmovg P2, P0
cmovle S2, P0
cmp S1, P1
cmovle P3, P1
cmovge S1, P1
cmp P3, S2
cmovle S0, S2
cmovle S2, P3
cmovg S0, P3
cmp S1, P2
mov S0, S1
