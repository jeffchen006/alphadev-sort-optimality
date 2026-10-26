# n=5 model=out iset=I1 prefix14_class=10837
cmp P1, P3
mov S2, P1
cmovge P1, P3
mov S0, P2
cmovle S2, P3
cmp P0, S0
cmovge P2, P0
cmovge P0, S0
cmp P2, S2
cmovge S0, P2
mov S1, P0
cmovge P2, S2
cmovg S2, S0
cmp P1, P0
