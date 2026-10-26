# n=5 model=out iset=I1 prefix14_class=4440
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P1, P0
cmovg S2, P1
mov S0, P3
cmovge P1, P0
cmovle S2, P0
cmp P3, S2
cmovle S0, S2
cmovg P3, S2
mov S0, P2
cmp P2, P1
