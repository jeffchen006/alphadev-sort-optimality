# n=5 model=out iset=I1 prefix14_class=6952
cmp P1, P0
mov S1, P1
cmovge P1, P0
cmovg P0, S1
mov S2, P3
cmp P2, S2
cmovle P3, P2
cmovge S2, P2
cmp P0, S2
cmovg S0, P0
cmovg P0, S2
cmovg S2, S0
cmp P3, P1
cmovge S1, P3
