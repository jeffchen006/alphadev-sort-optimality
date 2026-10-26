# n=5 model=out iset=I1 prefix14_class=9279
mov S2, P3
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P3, P1
