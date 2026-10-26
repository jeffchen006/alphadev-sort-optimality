# n=5 model=out iset=I1 prefix14_class=8790
cmp P1, P0
mov S0, P3
mov S2, P1
cmovge S2, P0
cmovle P1, P0
cmp P2, P3
cmovle S0, P2
cmovg P3, P2
cmp P1, P3
cmovge P0, P1
cmovge P1, P3
mov S1, S2
cmovge P3, P0
cmp S1, S0
