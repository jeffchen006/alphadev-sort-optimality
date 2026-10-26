# n=5 model=out iset=I1 prefix14_class=7446
mov S2, P1
cmp P2, P1
cmovge P1, P2
cmovg P2, S2
mov S0, P0
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
mov S1, P3
cmp P2, S0
cmovg P0, P2
cmovg P2, S0
cmovg S0, P0
cmp S1, P1
