# n=5 model=out iset=I1 prefix14_class=13174
cmp P1, P0
cmovg S2, P1
cmovg P1, P0
cmovg P0, S2
mov S1, P1
mov S0, P2
cmp P3, S0
cmovg P2, P3
cmovge P3, S0
cmp P3, P1
cmovg P1, P3
cmovge P3, S1
cmp P2, P0
cmovge S1, P0
