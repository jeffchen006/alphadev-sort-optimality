# n=5 model=out iset=I1 prefix14_class=1586
mov S1, P2
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovge P3, S0
cmp P1, S1
cmovge S1, P1
cmovle P2, P1
cmp P0, P2
mov S0, P0
cmovge S0, P2
cmovle P0, P2
mov S2, S1
cmp P3, S1
