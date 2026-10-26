# n=5 model=out iset=I1 prefix14_class=9263
cmp P1, P0
cmovge S2, P0
cmovg P0, P1
cmovg P1, S2
mov S0, P3
cmp P2, S0
cmovle P3, P2
cmovg S0, P2
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovg P3, S2
cmp P0, S0
cmovg S1, P0
