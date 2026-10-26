# n=5 model=out iset=I1 prefix14_class=10243
mov S1, P3
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P1, S1
cmovge P3, P1
mov S2, P3
cmovge P1, S1
cmp S2, P0
cmovle S2, P0
cmovge P3, P0
mov P0, P2
cmp P1, P2
