# n=5 model=out iset=I1 prefix14_class=6360
cmp P2, P1
cmovge S1, P2
cmovge P2, P1
cmovg P1, S1
cmp P0, P3
cmovle S0, P0
cmovg S0, P3
cmovge P3, P0
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovle S2, P3
mov P3, P2
cmp P2, S0
