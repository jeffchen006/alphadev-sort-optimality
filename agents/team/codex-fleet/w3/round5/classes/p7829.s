# n=5 model=out iset=I1 prefix14_class=7829
mov S1, P0
cmp P0, P3
cmovg P0, P3
mov S2, P0
cmovge P3, S1
cmp P1, P2
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P0, P1
cmovle S2, P1
cmovge P0, P1
mov P0, P3
cmp P3, P2
