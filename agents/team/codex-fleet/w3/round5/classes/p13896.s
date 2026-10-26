# n=5 model=out iset=I1 prefix14_class=13896
mov S0, P2
cmp S0, P0
cmovg P2, P0
mov S1, P1
cmovge P0, S0
cmp P3, S1
cmovg P1, P3
cmovg P3, S1
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
mov S2, P0
cmp P2, P3
