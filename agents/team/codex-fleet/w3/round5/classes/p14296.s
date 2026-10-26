# n=5 model=out iset=I1 prefix14_class=14296
cmp P0, P2
mov S1, P2
cmovg P2, P0
cmovle S1, P0
cmp P1, P3
mov P0, P1
cmovg P1, P3
cmovge P3, P0
cmp S1, P1
cmovge P0, S1
cmovge S1, P1
cmovg P1, P0
mov S0, P3
cmp P2, S0
