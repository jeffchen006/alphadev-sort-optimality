# n=5 model=out iset=I1 prefix14_class=8223
cmp P1, P2
cmovge S2, P2
cmovle S2, P1
cmovle P1, P2
mov S1, P3
mov S0, S2
cmp P0, P3
cmovge P3, P0
cmovg P0, S1
cmp S2, P0
cmovle S2, P0
cmovge S0, P0
mov S0, S2
cmp P3, P1
