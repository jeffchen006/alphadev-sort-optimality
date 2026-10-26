# n=5 model=out iset=I1 prefix14_class=1542
cmp P3, P2
mov S1, P3
cmovg S1, P2
cmovge P2, P3
cmovge P3, S1
cmp P0, P1
cmovle S0, P0
cmovg S0, P1
cmovge P1, P0
cmp S1, S0
cmovge S1, S0
cmovge S0, P3
cmp P1, P2
mov P3, P1
