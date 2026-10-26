# n=5 model=out iset=I1 prefix14_class=12488
mov S1, P0
cmp S1, P2
cmovg P0, P2
cmovge P2, S1
mov S0, P3
cmp P1, P3
cmovge P3, P1
cmovle S0, P1
cmp P0, S0
cmovge P1, S0
cmovge S0, P0
mov S2, S0
cmovge P0, P1
mov S1, P3
