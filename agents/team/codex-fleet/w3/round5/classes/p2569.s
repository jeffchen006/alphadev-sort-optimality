# n=5 model=out iset=I1 prefix14_class=2569
cmp P2, P1
cmovge S0, P1
cmovle S0, P2
mov S1, P0
cmovge P1, P2
cmp P3, S1
cmovge P0, P3
cmovge P3, S1
cmp P1, P0
mov S1, P1
cmovge P1, P0
cmovle S1, P0
cmp S0, P3
cmovle S2, P3
