# n=5 model=out iset=I1 prefix14_class=3069
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
cmovge P0, S0
cmp P3, P2
mov S1, P3
cmovge S1, P2
cmovle P3, P2
mov S2, P3
cmp P0, S1
cmovg P2, P0
cmovg P0, S1
cmovg S1, P2
cmp P1, S2
