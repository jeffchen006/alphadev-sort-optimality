# n=5 model=out iset=I1 prefix14_class=7220
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
mov S0, P0
cmovg P2, S1
cmp P3, S0
cmovge P0, P3
cmovg P3, S0
cmp P3, P1
mov S2, P1
cmovle S2, P3
cmovle P3, P1
mov S2, P3
cmp P0, P2
