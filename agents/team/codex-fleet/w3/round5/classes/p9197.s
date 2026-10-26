# n=5 model=out iset=I1 prefix14_class=9197
cmp P2, P3
cmovle S2, P3
cmovge S2, P2
cmovg P2, P3
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovge P1, S0
cmp P1, P2
cmovg S1, P1
cmovle S1, P2
cmovg P1, P2
cmp P0, S2
mov P2, P0
