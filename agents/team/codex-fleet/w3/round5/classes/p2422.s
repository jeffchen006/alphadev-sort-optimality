# n=5 model=out iset=I1 prefix14_class=2422
mov S1, P0
cmp S1, P1
mov S2, P3
cmovge P0, P1
cmovge P1, S1
cmp P2, P3
cmovle P3, P2
mov S0, P1
cmovge S2, P2
cmp S0, S2
cmovge P1, S2
cmovg S2, S0
cmp P0, P3
mov S2, P3
