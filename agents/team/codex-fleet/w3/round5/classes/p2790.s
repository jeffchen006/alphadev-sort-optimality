# n=5 model=out iset=I1 prefix14_class=2790
cmp P3, P2
mov S0, P0
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
mov S1, P2
cmp P0, P1
cmovle S0, P1
cmovg P0, P1
cmp S1, S0
cmovle P2, S0
mov P1, P3
cmovle S0, S1
cmovge S1, S0
