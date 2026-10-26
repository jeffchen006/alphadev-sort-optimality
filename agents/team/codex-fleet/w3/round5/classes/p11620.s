# n=5 model=out iset=I1 prefix14_class=11620
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
cmp P1, P2
cmovle S2, P1
cmovg S2, P2
cmovg P2, P1
cmp P0, P2
cmovle S1, P2
cmovge S1, P0
cmovge P0, P2
mov P1, P3
cmp P3, S2
