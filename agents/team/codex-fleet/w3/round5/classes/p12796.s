# n=5 model=out iset=I1 prefix14_class=12796
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
cmovge P0, P3
mov S2, P1
cmp S2, P2
cmovg P1, P2
cmovg P2, S2
cmp S1, P1
cmovg S0, S1
cmovg S1, P1
cmovg P1, S0
mov S1, P0
cmp S1, P2
