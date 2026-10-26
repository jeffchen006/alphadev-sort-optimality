# n=5 model=out iset=I1 prefix14_class=10569
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
mov S0, P2
cmovg P0, S1
cmp P3, P2
cmovge P2, P3
cmovg P3, S0
mov S2, P0
cmp P0, P2
cmovle P0, P2
cmovge S2, P2
cmp P1, P3
cmovle S1, P3
