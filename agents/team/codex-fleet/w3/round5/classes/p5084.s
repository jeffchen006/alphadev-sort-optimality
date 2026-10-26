# n=5 model=out iset=I1 prefix14_class=5084
cmp P2, P0
mov S1, P0
cmovge S1, P2
cmovge P2, P0
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
mov S0, P1
cmp P2, P1
cmovle S0, P2
cmovge P1, P2
cmp P3, S1
cmovg S2, S1
