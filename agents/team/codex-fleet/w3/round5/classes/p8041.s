# n=5 model=out iset=I1 prefix14_class=8041
cmp P2, P1
cmovge S0, P2
mov S1, P3
cmovg P2, P1
cmovge P1, S0
cmp P0, S1
cmovge P3, P0
cmovge P0, S1
cmp P0, P2
mov S2, P0
cmovle P0, P2
cmovg S2, P2
cmp P1, P3
mov S2, P1
