# n=5 model=out iset=I1 prefix14_class=5735
cmp P2, P1
cmovge S2, P1
cmovge P1, P2
cmovge P2, S2
cmp P3, P0
cmovg S0, P0
cmovg P0, P3
cmovg P3, S0
cmp P2, P3
cmovle S2, P2
cmovg S2, P3
cmovge P3, P2
cmp P0, P1
cmovle P2, P0
