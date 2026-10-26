# n=5 model=out iset=I1 prefix14_class=13881
mov S0, P2
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
cmp P0, P1
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
cmp P0, P2
cmovg P3, P2
