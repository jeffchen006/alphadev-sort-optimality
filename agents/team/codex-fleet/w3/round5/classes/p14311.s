# n=5 model=out iset=I1 prefix14_class=14311
mov S2, P2
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovle P0, S0
cmp P3, S2
cmovg P2, P3
cmovg P3, S2
mov S1, P1
cmp P3, S1
cmovg S1, P3
cmovge P3, P1
cmp P2, P0
cmovle S2, P0
