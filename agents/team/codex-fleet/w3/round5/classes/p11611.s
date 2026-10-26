# n=5 model=out iset=I1 prefix14_class=11611
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
mov S1, P1
cmovg P3, S0
cmp P0, P1
cmovg S1, P0
cmovge P0, P1
cmp S1, P3
cmovg S2, P3
cmovge P3, S1
mov P1, P2
cmovg S1, S2
cmp P0, P1
