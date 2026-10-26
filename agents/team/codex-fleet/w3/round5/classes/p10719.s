# n=5 model=out iset=I1 prefix14_class=10719
mov S2, P0
cmp P2, S2
cmovle S2, P2
cmovle P2, P0
cmp P1, P3
mov S0, P3
mov S1, P2
cmovge P3, P1
cmovle S0, P1
cmp P3, S1
cmovg P2, P3
cmovge P3, S1
cmp S2, S0
cmovge P0, S0
