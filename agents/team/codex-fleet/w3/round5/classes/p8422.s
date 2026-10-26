# n=5 model=out iset=I1 prefix14_class=8422
mov S1, P0
cmp S1, P2
cmovge S1, P2
cmovge P2, P0
cmp P1, P3
mov S0, P1
cmovg S0, P3
cmovge P3, P1
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
mov P0, S0
cmp S1, S0
