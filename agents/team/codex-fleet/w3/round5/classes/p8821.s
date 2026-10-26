# n=5 model=out iset=I1 prefix14_class=8821
mov S0, P1
mov S2, P2
cmp S2, P0
cmovg S2, P0
cmovg P0, P2
cmp S0, P3
cmovg S0, P3
cmovg P3, P1
cmp P0, P3
cmovge P1, P3
cmovg P3, P0
cmovge P0, P1
mov S1, S0
cmp S2, S1
