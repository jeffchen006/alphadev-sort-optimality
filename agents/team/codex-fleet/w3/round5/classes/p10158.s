# n=5 model=out iset=I1 prefix14_class=10158
cmp P1, P3
mov S2, P1
mov S1, P0
cmovg P1, P3
cmovg P3, S2
cmp P2, S1
cmovge S1, P2
cmovge P2, P0
cmp S1, P3
cmovge S2, P3
mov S0, P2
cmovg P3, S1
cmovg S1, S2
cmp S0, P1
