# n=5 model=out iset=I1 prefix14_class=367
mov S2, P3
cmp P1, S2
cmovge P3, P1
cmovg P1, S2
cmp P0, P2
mov S1, P1
cmovg S0, P0
cmovge P0, P2
cmovg P2, S0
mov S2, P2
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmp P3, P2
