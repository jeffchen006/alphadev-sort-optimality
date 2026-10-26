# n=5 model=out iset=I1 prefix14_class=6371
cmp P0, P3
mov S1, P0
cmovge P0, P3
cmovge P3, S1
cmp P1, P2
cmovle S0, P1
cmovge S0, P2
mov S2, P3
cmovge P2, P1
cmp P2, S2
cmovg P3, P2
mov P3, S0
cmovle S2, P2
mov P2, S2
