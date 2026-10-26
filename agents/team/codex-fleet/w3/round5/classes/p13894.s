# n=5 model=out iset=I1 prefix14_class=13894
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovge P1, P2
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P0, P1
mov S1, P1
cmovg P1, P0
cmovge P0, S1
cmp P3, S2
cmovg P1, S2
