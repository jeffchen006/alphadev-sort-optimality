# n=5 model=out iset=I1 prefix14_class=1804
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
cmp P2, P0
mov S2, P1
mov S0, P0
cmovg P0, P2
cmovg P2, S0
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovg S0, P3
cmp P2, P1
