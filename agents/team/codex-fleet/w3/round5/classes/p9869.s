# n=5 model=out iset=I1 prefix14_class=9869
cmp P1, P0
mov S0, P2
mov S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
mov S1, P0
cmp S0, P0
cmovg S1, S0
cmovg S0, P0
cmp P1, P3
cmovge P0, S0
