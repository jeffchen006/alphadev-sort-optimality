# n=5 model=out iset=I1 prefix14_class=7832
mov S0, P2
mov S2, P3
cmp S0, P1
cmovge S0, P1
cmovge P1, P2
cmp P0, S2
cmovle P3, P0
cmovge S2, P0
mov P2, S0
cmp P3, S0
cmovg P2, P3
cmovle S0, P3
cmp S2, P1
cmovge P3, P1
