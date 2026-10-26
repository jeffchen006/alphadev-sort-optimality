# n=5 model=out iset=I1 prefix14_class=8866
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
mov S1, P1
cmovge P3, P2
cmp P0, S1
cmovge P1, P0
cmovge P0, S1
cmp P3, P1
cmovge S2, P1
cmovle S2, P3
cmovg P1, P3
cmp S0, P0
cmovle S1, S0
