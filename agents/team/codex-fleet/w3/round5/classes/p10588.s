# n=5 model=out iset=I1 prefix14_class=10588
cmp P0, P2
cmovg S0, P0
cmovg P0, P2
mov S2, P1
cmovg P2, S0
cmp P3, S2
cmovge P1, P3
cmovle S2, P3
cmovle P3, P1
cmp P3, P2
cmovle P3, P2
cmovle P2, P1
cmp P0, S2
cmovge S1, S2
