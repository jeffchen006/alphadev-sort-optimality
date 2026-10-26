# n=5 model=out iset=I1 prefix14_class=2458
cmp P0, P2
mov S2, P0
cmovle S2, P2
mov S0, P3
cmovg P0, P2
cmp P1, P3
cmovg P3, P1
cmovge P1, S0
cmovg S0, P3
cmp P3, S2
cmovle S0, S2
cmovle S2, P3
cmp P1, P0
cmovle S0, P0
