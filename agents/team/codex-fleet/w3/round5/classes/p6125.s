# n=5 model=out iset=I1 prefix14_class=6125
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovle P1, S1
mov S1, P3
cmp P0, S1
cmovg S1, P0
cmovge P0, P3
cmp P1, S1
mov S0, P0
cmovg S2, P1
cmovg P1, S1
cmovg S1, S2
cmp P2, S0
