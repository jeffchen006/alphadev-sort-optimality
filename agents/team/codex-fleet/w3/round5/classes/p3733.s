# n=5 model=out iset=I1 prefix14_class=3733
cmp P2, P3
cmovle S2, P3
cmovg S2, P2
cmovle P3, P2
cmovge P2, P3
mov S0, P0
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp P1, P3
cmovg P2, P1
cmovle P3, P1
cmp S2, P0
cmovle S1, P0
