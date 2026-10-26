# n=5 model=out iset=I1 prefix14_class=1372
cmp P2, P3
cmovle S2, P2
cmovg S2, P3
mov S1, P0
cmovg P3, P2
cmp S1, P1
cmovge S1, P1
cmovg P1, P0
mov S0, P3
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmp S2, S1
mov P0, P1
