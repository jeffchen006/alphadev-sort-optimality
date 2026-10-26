# n=5 model=out iset=I1 prefix14_class=84
mov S0, P3
cmp P2, S0
cmovge P3, P2
mov S1, P1
cmovg P2, S0
cmp P0, S1
cmovg S1, P0
cmovg P0, P1
mov S0, S1
cmp P0, P2
cmovg P1, P0
cmovge P0, P2
cmovg P2, P1
cmp S1, P3
