# n=5 model=out iset=I1 prefix14_class=13906
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
mov S1, P3
cmovle P2, S0
cmp P1, P3
cmovge P3, P1
cmovg P1, S1
cmp P3, P2
cmovge S0, P2
mov S2, P1
cmovg P2, P3
cmovge P3, S0
cmp P1, P0
