# n=5 model=out iset=I1 prefix14_class=13745
mov S2, P3
cmp P3, P2
cmovle S2, P2
cmovg P3, P2
cmp P1, P0
mov S0, P3
cmovg P2, P0
cmovge P0, P1
cmovg P1, P2
cmp S2, P0
cmovge S1, S2
cmovg S2, P0
cmovge P0, S1
cmp S0, P1
