# n=5 model=out iset=I1 prefix14_class=13876
cmp P3, P2
mov S0, P3
cmovg P3, P2
cmovge P2, S0
cmp P0, P1
mov S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
cmp P0, P3
cmovge S1, P3
