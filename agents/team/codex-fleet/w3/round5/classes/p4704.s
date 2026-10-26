# n=5 model=out iset=I1 prefix14_class=4704
mov S2, P3
cmp P2, P3
mov S0, P1
cmovle S2, P2
cmovge P3, P2
cmp S0, P0
cmovge P1, P0
cmovg P0, S0
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
cmovle S0, P0
cmp P1, S2
cmovge S1, S2
