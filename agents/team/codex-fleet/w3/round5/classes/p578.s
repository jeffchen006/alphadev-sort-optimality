# n=5 model=out iset=I1 prefix14_class=578
cmp P1, P2
cmovle S2, P2
cmovge S2, P1
cmovg P1, P2
cmp P0, P3
mov P2, S2
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P3, P2
cmovle P2, P3
cmovg S2, P3
mov S1, P1
cmp P0, P1
