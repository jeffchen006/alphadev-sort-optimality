# n=5 model=out iset=I1 prefix14_class=1423
mov S0, P1
mov S2, P2
cmp S0, P0
cmovg S0, P0
cmovge P0, P1
cmp P3, S2
cmovge P2, P3
mov P1, P2
cmovge P3, S2
cmp P2, P0
cmovle P1, P0
cmovge P2, P0
cmp P3, S0
cmovge S1, P3
