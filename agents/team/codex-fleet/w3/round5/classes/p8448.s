# n=5 model=out iset=I1 prefix14_class=8448
mov S0, P1
cmp P3, S0
cmovg S0, P3
mov S2, P2
cmovge P3, P1
cmp P0, S2
cmovg P2, P0
cmovg P0, S2
cmp P2, S0
cmovge P1, S0
cmovge S0, P2
cmovge P2, P1
mov S2, P3
mov S0, P2
