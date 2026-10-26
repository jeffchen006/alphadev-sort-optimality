# n=5 model=out iset=I1 prefix14_class=10160
mov S1, P0
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P1, S1
cmovg S1, P1
cmovge P1, P0
cmp S1, P3
cmovge S2, P3
mov S0, P1
cmovg P3, S1
cmovg S1, S2
cmp S0, P2
