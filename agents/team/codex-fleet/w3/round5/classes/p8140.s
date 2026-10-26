# n=5 model=out iset=I1 prefix14_class=8140
cmp P3, P2
cmovg S0, P2
cmovle S0, P3
cmovge P2, P3
cmp P1, P0
cmovge P3, P0
mov S2, S0
cmovg P0, P1
cmovg P1, P3
cmp S2, P1
cmovg S2, P1
cmovle S0, P1
cmp P0, P2
cmovle P3, P0
