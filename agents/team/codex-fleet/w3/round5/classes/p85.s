# n=5 model=out iset=I1 prefix14_class=85
mov S0, P1
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
mov S1, P3
cmp P0, S1
cmovg S1, P0
cmovge P0, P3
cmp P0, P2
mov S0, S1
cmovge P3, P0
cmovge P0, P2
cmovge P2, P3
cmp S1, P1
