# n=5 model=out iset=I1 prefix14_class=6823
mov S0, P3
cmp P1, P3
mov S2, P0
cmovle P3, P1
cmovle P1, S0
cmp P2, S2
cmovge P0, P2
cmovle S2, P2
cmp P0, P1
cmovge S0, P1
cmovge P1, P0
mov S1, S2
cmovg P0, S0
cmp P3, S2
