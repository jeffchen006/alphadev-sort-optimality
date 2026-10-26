# n=5 model=out iset=I1 prefix14_class=12259
cmp P3, P1
mov S0, P1
cmovle S0, P3
mov S1, P0
cmovge P1, P3
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
mov P3, P2
cmp P3, S0
cmovg P3, S0
cmovg S0, P2
cmp P0, P1
cmovle S2, P0
