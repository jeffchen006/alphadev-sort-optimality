# n=5 model=out iset=I1 prefix14_class=12150
cmp P0, P2
mov S1, P1
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P3, P1
cmovg S1, P3
cmovge P3, P1
cmp P0, P3
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
cmp P2, S1
cmovge S0, S1
