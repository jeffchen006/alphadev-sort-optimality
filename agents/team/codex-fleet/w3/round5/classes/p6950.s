# n=5 model=out iset=I1 prefix14_class=6950
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovge P0, S1
mov S2, P3
cmp P2, S2
cmovge S2, P2
cmovle P3, P2
cmp P0, S2
cmovg P2, P0
cmovge P0, S2
cmovg S2, P2
cmp P3, P1
cmovge S0, P3
