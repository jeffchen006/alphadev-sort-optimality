# n=5 model=out iset=I1 prefix14_class=4740
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovg S0, P2
cmp P1, P3
cmovge P2, P3
mov S1, S0
cmovge P3, P1
cmovge P1, P2
cmp P1, S0
cmovg S0, P1
cmovge P1, S1
mov S2, S0
cmp P3, P0
