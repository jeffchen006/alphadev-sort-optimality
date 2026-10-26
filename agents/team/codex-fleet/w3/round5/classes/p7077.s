# n=5 model=out iset=I1 prefix14_class=7077
mov S1, P3
cmp P0, P3
cmovg S1, P0
cmovge P0, P3
cmp P1, P2
cmovge S0, P1
cmovge P1, P2
mov S2, P0
cmovg P2, S0
cmp P1, S2
cmovle S2, P1
mov P3, S1
cmovle P1, P0
cmovg P0, P1
