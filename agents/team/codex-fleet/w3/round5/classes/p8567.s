# n=5 model=out iset=I1 prefix14_class=8567
mov S1, P1
cmp P2, P1
cmovle S1, P2
cmovg P1, P2
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
mov P2, P1
cmp P0, P1
cmovge P2, P0
cmovge P0, P1
cmp S1, P3
cmovle S0, S1
