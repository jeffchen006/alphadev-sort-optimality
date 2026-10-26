# n=5 model=out iset=I1 prefix14_class=14254
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovg P1, S2
mov S0, P2
cmp P0, S0
cmovge P2, P0
cmovge P0, S0
cmp P3, P2
cmovle S1, P2
cmovge S1, P3
cmovg P3, P2
cmp P1, P0
cmovge S0, P1
