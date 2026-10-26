# n=5 model=out iset=I1 prefix14_class=14243
mov S2, P2
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovge P3, S1
cmp P1, S2
cmovge P2, P1
mov S0, P0
cmovle S2, P1
cmp P0, P2
cmovg S0, P2
cmovg P2, P0
mov P2, P3
cmp P3, S2
