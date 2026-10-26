# n=5 model=out iset=I1 prefix14_class=6649
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
mov S2, P3
cmovge P0, S0
cmp P2, S2
cmovge P3, P2
cmovg P2, S2
cmp P3, P1
cmovg S0, P3
cmovg P3, P1
cmovle S0, P1
cmp P0, P2
cmovle S1, P2
