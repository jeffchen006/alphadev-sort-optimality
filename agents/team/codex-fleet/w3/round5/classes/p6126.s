# n=5 model=out iset=I1 prefix14_class=6126
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovle P1, S1
mov S1, P0
cmp P3, S1
cmovg S1, P3
cmovge P3, P0
cmp P1, S1
mov S2, P3
cmovg S0, P1
cmovg P1, S1
cmovg S1, S0
cmp P2, S2
