# n=5 model=out iset=I1 prefix14_class=8855
mov S2, P3
mov S0, P1
cmp P3, P2
cmovle S2, P2
cmovge P3, P2
cmp S0, P0
cmovg S0, P0
cmovg P0, P1
cmp P0, S2
mov P2, P3
cmovge S1, S2
cmovg S2, P0
cmovge P0, S1
cmp P3, S0
