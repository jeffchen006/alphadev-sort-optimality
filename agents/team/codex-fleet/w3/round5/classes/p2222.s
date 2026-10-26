# n=5 model=out iset=I1 prefix14_class=2222
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
mov S2, P2
cmovg P3, S1
cmp P1, S2
cmovg P2, P1
mov S0, P2
cmovge P1, S2
cmp S0, P0
cmovle S0, P0
mov S0, P1
cmovle P0, P2
cmp P3, P1
