# n=5 model=out iset=I1 prefix14_class=331
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
mov S0, P3
cmovg P0, S1
cmp P1, S0
cmovg P3, P1
cmovle S0, P1
cmovge P1, S0
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmp P3, P0
mov S2, P0
