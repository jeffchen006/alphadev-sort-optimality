# n=5 model=out iset=I1 prefix14_class=3446
mov S1, P0
mov S0, P1
cmp P2, S0
cmovge S0, P2
cmovge P2, P1
cmp S1, P3
cmovg S1, P3
cmovle P0, P3
cmp S1, P2
cmovg S2, P2
mov P3, P0
cmovge P2, S1
cmovg S1, S2
cmp S0, P3
