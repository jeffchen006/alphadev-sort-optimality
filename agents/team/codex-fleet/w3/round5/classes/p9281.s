# n=5 model=out iset=I1 prefix14_class=9281
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovg P1, S2
cmp P0, P2
cmovg S1, P2
mov S0, P3
cmovge P2, P0
cmovg P0, S1
cmp P3, P1
