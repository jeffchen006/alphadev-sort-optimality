# n=5 model=out iset=I1 prefix14_class=9980
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovg S2, P3
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovle P0, P1
cmp P0, S2
cmovg P1, P0
cmovle P1, S2
cmovge P0, S2
cmp S0, P2
cmovle S1, S0
