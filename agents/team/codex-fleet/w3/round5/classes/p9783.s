# n=5 model=out iset=I1 prefix14_class=9783
cmp P1, P3
mov S0, P0
cmovg S2, P1
cmovle S2, P3
cmovg P1, P3
mov S1, S2
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmp S1, S0
cmovle S2, S0
cmovg S1, S0
cmp P2, P1
cmovg P3, P2
