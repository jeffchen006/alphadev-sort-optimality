# n=5 model=out iset=I1 prefix14_class=837
cmp P2, P1
cmovle S2, P1
mov S0, P3
cmovg S2, P2
cmovge P2, P1
cmp P3, P0
cmovg S0, P0
cmovg P0, P3
cmp P0, S2
cmovge S1, S2
cmovle S1, P0
cmovg S2, P0
cmovg P0, S1
mov P3, S0
