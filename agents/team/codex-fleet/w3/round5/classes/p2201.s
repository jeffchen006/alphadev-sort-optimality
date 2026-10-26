# n=5 model=out iset=I1 prefix14_class=2201
cmp P0, P3
cmovg S0, P0
cmovge P0, P3
mov S2, P2
cmovle S0, P3
cmp P1, P2
cmovg P2, P1
cmovge P1, S2
mov S1, P2
cmp P2, S0
cmovle S1, S0
cmovle S0, P2
cmp P1, P0
cmovle P2, P1
