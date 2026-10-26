# n=5 model=out iset=I1 prefix14_class=13156
mov S1, P0
cmp P1, P0
cmovle P0, P1
cmovle P1, S1
cmp P2, P3
mov S2, P2
cmovge P2, P3
cmovle S2, P3
cmp P0, P2
cmovg P3, P0
cmovg P0, P2
cmovg P2, P3
mov S0, S2
cmp S2, P1
