# n=5 model=out iset=I1 prefix14_class=11789
cmp P2, P0
cmovg S2, P0
cmovge P0, P2
cmovg P2, S2
mov S1, P3
cmp P1, S1
cmovle S1, P1
cmovle P1, P3
cmovge P3, P1
cmp P0, P1
cmovle P3, P0
cmovle P0, P1
cmp P2, S1
cmovge S0, P2
