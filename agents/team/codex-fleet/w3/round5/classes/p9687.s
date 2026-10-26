# n=5 model=out iset=I1 prefix14_class=9687
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovle S0, P0
mov S2, P2
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmp P1, P3
cmovge P2, P1
cmovge P1, P3
mov P0, S2
cmovg P3, P2
cmp S0, S2
