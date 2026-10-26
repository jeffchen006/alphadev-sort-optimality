# n=5 model=out iset=I1 prefix14_class=9418
mov S1, P0
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovge P1, P2
cmp P3, P0
cmovle P0, P3
cmovle P3, S1
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovg P1, S2
cmp S0, P3
cmovle S1, P3
