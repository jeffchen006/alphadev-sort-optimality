# n=5 model=out iset=I1 prefix14_class=6768
cmp P2, P1
mov S2, P3
cmovle S1, P2
cmovle P2, P1
cmovge S1, P1
cmp P0, P3
cmovg P3, P0
cmovg P0, S2
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P0, S1
cmovge S2, P0
