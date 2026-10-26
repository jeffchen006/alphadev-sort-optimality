# n=5 model=out iset=I1 prefix14_class=8883
mov S1, P2
mov S2, P3
cmp P1, S1
cmovg S1, P1
cmovge P1, P2
cmp S2, P0
cmovg P3, P0
cmovge P0, S2
mov S0, P1
cmp S1, P0
cmovg P2, P0
cmovg P0, S1
cmovg S1, P2
cmp S0, P3
