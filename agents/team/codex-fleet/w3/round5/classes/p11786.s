# n=5 model=out iset=I1 prefix14_class=11786
mov S2, P0
cmp P1, P2
mov S0, P2
cmovg P2, P1
cmovge P1, S0
cmp P3, P0
cmovle P0, P3
cmovge S2, P3
mov S1, S2
cmp P2, S2
cmovge S2, P2
cmovge P2, S1
cmp P0, P1
cmovg S0, P0
