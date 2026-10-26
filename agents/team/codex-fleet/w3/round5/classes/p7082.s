# n=5 model=out iset=I1 prefix14_class=7082
mov S1, P0
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
mov S2, P3
cmp P2, P1
cmovg S0, P2
cmovge P2, P1
mov P0, S1
cmovg P1, S0
cmp P2, S2
cmovg P3, P2
cmovle S2, P2
cmp P1, S1
