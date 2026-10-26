# n=5 model=out iset=I1 prefix14_class=1011
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovle P2, P1
mov S0, P3
cmp P3, P0
cmovge P3, P0
mov P1, S2
cmovg P0, S0
cmp P0, P1
cmovge S2, P0
cmovg P0, P1
cmp P3, P2
mov S1, P0
