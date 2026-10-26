# n=5 model=out iset=I1 prefix14_class=8635
cmp P0, P2
mov S0, P0
cmovge S0, P2
cmovg P2, P0
cmp P1, P3
cmovge P0, P1
cmovg P1, P3
cmovg P3, P0
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovge P3, P2
cmp P1, S0
cmovge S1, P1
