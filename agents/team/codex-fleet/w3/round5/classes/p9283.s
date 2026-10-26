# n=5 model=out iset=I1 prefix14_class=9283
cmp P2, P3
mov S2, P2
cmovg P2, P3
cmovge P3, S2
cmp P1, P0
cmovge S2, P1
mov S0, P3
cmovg P1, P0
cmovge P0, S2
cmp P1, P2
cmovg S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P3, P0
