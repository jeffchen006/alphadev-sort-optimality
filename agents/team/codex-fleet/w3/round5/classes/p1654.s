# n=5 model=out iset=I1 prefix14_class=1654
cmp P0, P3
mov S1, P1
cmovg S2, P3
cmovg P3, P0
cmovg P0, S2
cmp P1, P2
cmovg P1, P2
cmovge P2, S1
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovg S0, P0
cmp P3, P2
cmovge S2, P3
