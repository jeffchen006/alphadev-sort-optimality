# n=5 model=out iset=I1 prefix14_class=5629
cmp P3, P0
cmovle S2, P0
cmovg S2, P3
cmovge P3, P0
cmp P1, P2
mov S0, P3
cmovle P0, P1
cmovle P1, P2
cmovle P2, P0
cmp S0, P2
cmovg P3, P2
cmovg P2, S0
cmp S2, P1
cmovge P3, S2
