# n=5 model=out iset=I1 prefix14_class=1820
mov S0, P1
cmp P2, S0
mov S2, P3
cmovge P1, P2
cmovg P2, S0
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
cmp S2, P1
cmovle P3, S2
cmovg P3, P1
cmovle S2, P1
mov S2, P0
cmp P2, S2
