# n=5 model=out iset=I1 prefix14_class=9385
cmp P0, P1
mov S0, P3
cmovg S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P3, P2
mov S2, P1
cmovle S0, P2
cmovle P2, P3
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovge P0, S1
cmp S2, S0
