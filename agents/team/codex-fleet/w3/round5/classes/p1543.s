# n=5 model=out iset=I1 prefix14_class=1543
cmp P3, P2
mov S2, P3
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovg P1, P0
cmp S2, S0
cmovg S2, S0
cmovge S0, P3
cmp P2, P1
mov P3, P2
