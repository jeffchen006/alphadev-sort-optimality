# n=5 model=out iset=I1 prefix14_class=8889
cmp P2, P3
cmovle S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P0, P1
cmovg S2, P0
cmovg P0, P1
cmovg P1, S2
mov P3, P0
cmp P1, S1
cmovge S0, P1
cmovge P1, S1
cmovle S0, S1
cmp P3, P2
